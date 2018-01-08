class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/release_0.4.tar.gz"
  sha256 "e9460eb489e0ef6d1496afed2dae2e41c94005c85737ff53a8c09d51b6f93074"
  revision 1
  head "https://github.com/jtsiomb/libdrawtext.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bb5ce8c08995d65a2ebeb481e0ae7cc81220d4557d8748d2ecb68adb413a5a98" => :high_sierra
    sha256 "afa2dfbd5253bf1730b609d037de4e836d949b7e1d9ea6d618580ed6c2a06f9c" => :sierra
    sha256 "2547c5dc61bedc3fbcddfced76e68a5b280e062c37bdc46cf133fcec9ea4625a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "-C", "tools/font2glyphmap"
    system "make", "-C", "tools/font2glyphmap", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    ext = (MacOS.version >= :high_sierra) ? "otf" : "ttf"
    cp "/System/Library/Fonts/LastResort.#{ext}", testpath
    system bin/"font2glyphmap", "LastResort.#{ext}"
    bytes = File.read("LastResort_s12.glyphmap").bytes.to_a[0..12]
    assert_equal [80, 54, 10, 53, 49, 50, 32, 50, 53, 54, 10, 35, 32], bytes
  end
end

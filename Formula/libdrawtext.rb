class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  url "https://github.com/jtsiomb/libdrawtext/archive/v0.5.tar.gz"
  sha256 "7eea99dbf9c86698b5b00ad7f0675b9327098112bf5c11f1bad0635077eae8a9"
  head "https://github.com/jtsiomb/libdrawtext.git"

  bottle do
    cellar :any
    sha256 "2296791192489056bf3a3931d2a92a5f18556fd791647d913e05405ab43756c0" => :mojave
    sha256 "083925ec6bef64deb7468f7a77c0f1238e846ab06eaed81f0dd5ca148710060e" => :high_sierra
    sha256 "89217ea93b789d24a63ab479966abec68b6c7575309e03e7314de578f460c81c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  patch do
    url "https://github.com/jtsiomb/libdrawtext/commit/543cfc67beb76e2c25df0a329b5d38eff9d36c71.diff?full_index=1"
    sha256 "a2d7ad77e7f1a4590ca85754de2f9961c921c34723f6c86cdd23395cc3566be0"
  end

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

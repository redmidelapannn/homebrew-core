class Libdatrie < Formula
  desc "Double-Array Trie Library"
  homepage "https://linux.thai.net/projects/datrie"
  url "https://github.com/tlwg/libdatrie/releases/download/v0.2.12/libdatrie-0.2.12.tar.xz"
  sha256 "452dcc4d3a96c01f80f7c291b42be11863cd1554ff78b93e110becce6e00b149"

  bottle do
    cellar :any
    sha256 "55ec3287b4d4ae186f29f481d125df648eb7d11180676c18fa865f31d5fd62fa" => :mojave
    sha256 "7f2cc96620d013833a25574fb122a5f6a61d509afb6f4e4594a4b85620b0629b" => :high_sierra
    sha256 "174421980f65077fc93b7dd506c8751ea12b2aacb39ec608f291257876290ca5" => :sierra
    sha256 "44a7411495a05da3a2e52539fdb14976d1c9d04c0085eb34d014e06c8fc0d54d" => :el_capitan
  end

  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make", "install-am"
    system "make", "install-exec"
  end

  test do
    system "make" "check"
  end
end

class Libsvg < Formula
  desc "Library for SVG files"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-0.1.4.tar.gz"
  sha256 "4c3bf9292e676a72b12338691be64d0f38cd7f2ea5e8b67fbbf45f1ed404bc8f"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "b1f6207b248a9495828a63290a7503a11e5e9826c169e20416c39b680a7c19a9" => :el_capitan
    sha256 "a0a44509e48fddc50a0202e1e9f5a3b09e319e36569c197f0cad2f2df1cb4833" => :yosemite
    sha256 "d1bbb1379c95f8898ff6aaba0fda988700dec7f53cdd64a83e0631c94cb3d83a" => :mavericks
  end

  depends_on "libpng"
  depends_on "pkg-config" => :build
  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

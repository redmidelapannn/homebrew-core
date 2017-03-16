class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://www.libdmtx.org/"
  url "https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/libdmtx-0.7.4.tar.bz2"
  sha256 "b62c586ac4fad393024dadcc48da8081b4f7d317aa392f9245c5335f0ee8dd76"

  bottle do
    cellar :any
    rebuild 2
    sha256 "9206b6837d12b8a89ba7a7752989e21ccb506b9265f51c435c71d24ed3873883" => :sierra
    sha256 "cbc966304cd966f84d78905000f480712d87bd360637f0ed87334f3c41c2b37a" => :el_capitan
    sha256 "c7d88379a32c611ba81b92ec6739a46bef10a19cbd286d233d28f6bcce435f45" => :yosemite
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

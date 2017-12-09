class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/2.2.tar.gz"
  sha256 "25607db12f466ba88a1454ef8b378e0e9eb59adffad6baa4b5610859a102a5dd"
  revision 1
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "fea0c066f8fa45b48f3ce5c65bc074e9e8bb3d0d86d49d1f564ef51ef00655f0" => :high_sierra
    sha256 "0506a154212f5919fb22bb3c6f3a5b44a383997fda48ae0b535df953315ba399" => :sierra
    sha256 "a3697881b5b122a5e81308e04e1787acc55f9a97b8e3aadde56445d6ac13a81d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-c"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end

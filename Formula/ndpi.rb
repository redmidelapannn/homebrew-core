class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "http://www.ntop.org/products/ndpi/"
  url "https://github.com/ntop/nDPI/archive/1.8.tar.gz"
  sha256 "cea26a7f280301cc3a0e714b560d48b57ae2cf6453b71eb647ceb3fccecb5ba2"

  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    rebuild 2
    sha256 "01f587f502c675f7208d61ed40b17f107d296aec15de923a9948ac5efedca8b7" => :sierra
    sha256 "e5beaf994d1f51a8bd4fa41a18689e84749514a4accf3ba0a42c7b2fdc4d9960" => :el_capitan
    sha256 "7c948f1b914b8ad77af35e99e03838e20e185b4d59a1e06be3d64b6dbf555484" => :yosemite
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

class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/2.0.tar.gz"
  sha256 "a42a60ebd64bc8606f780204222893027f6dce0e3b460d7be655e5e065f5f3fa"
  revision 1
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7d0b1068412a8595eb936a8f7ae805ace7bcaba8b48efaf8d8b9d8cb366e2fdd" => :high_sierra
    sha256 "ed27525a5680b5d099d5301a892f7a92eb1ca2aadc6466997b87b75f75079210" => :sierra
    sha256 "975638bebba0ee9de8f7bfd8c74971cbe1d455f122402b98b192ca15809e0976" => :el_capitan
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

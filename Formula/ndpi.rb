class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/3.2.tar.gz"
  sha256 "6808c8c4495343e67863f4d30bb261c1e2daec5628ae0be257ba2a2dea7ec70a"
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "9bbe3fa7dbccdba09be3f23b3af2a51c654baa6d4d616aa2f754b71ff17fe298" => :catalina
    sha256 "7dcdbd9f3958833129c2eeaec09254c307586950368da5808f492c377aad885a" => :mojave
    sha256 "c1271dd6d846ee9a906d1c0a8d011a5ebb4eaec5c8d39241ab7360b1459cfd3e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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

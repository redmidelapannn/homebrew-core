class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.14.2.tar.gz"
  sha256 "e0ac23f01a953fcc6290c96799deeffb32aa76ca8e216c564d20c18e75a25219"
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4cd5df718fca90182c8e0c12bb16d1ad9a03d403081b500ef50fda55a636e0d6" => :sierra
    sha256 "ad2dac9159b750755b97f194cfc7a3f78e10efea9d4a5f9d464541eca0c59aab" => :el_capitan
    sha256 "5953c912b19a1bc301f6b105bf10fac0bb046ddc83f0a4a0266603981abf5cba" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end

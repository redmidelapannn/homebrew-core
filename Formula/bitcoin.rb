class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.14.2.tar.gz"
  sha256 "e0ac23f01a953fcc6290c96799deeffb32aa76ca8e216c564d20c18e75a25219"
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ec366401c85a26281c4ea2d2bd2d8f3c8a7ee45e86a1babbf5366f5df1036762" => :sierra
    sha256 "467177fe1fccdb891c360d8749e088a4ff5bdf967f77575b9fa526216f4a41af" => :el_capitan
    sha256 "acad7c301cdaa756ba49122dd6a38bf0a7c48b12e7783333e9f01a70aeaa8ad9" => :yosemite
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

  needs :cxx11

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

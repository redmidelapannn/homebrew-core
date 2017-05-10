class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "https://digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.5.tar.gz"
  sha256 "f39fed437911b858c97937bc902f68f9a690753617abe825411a8483a7f70c72"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5a73e861dc04984138e29b479b27d0ef365969770961dbfeffc09b3974bad842" => :sierra
    sha256 "53b08f6a882984b10cd1bf1f066440fd07e40a5f843095370ffb35b2cdd17079" => :el_capitan
    sha256 "89c365c1f64a6a3eb51d0b14bca73740cb4b3db7a6de0c02cdb50efd8f724d92" => :yosemite
  end

  head do
    url "https://github.com/simsong/tcpflow.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost" => :build
  depends_on "sqlite" if MacOS.version < :lion
  depends_on "openssl"

  def install
    system "bash", "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

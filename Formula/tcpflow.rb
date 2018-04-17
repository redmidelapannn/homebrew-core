class Tcpflow < Formula
  desc "TCP flow recorder"
  homepage "https://github.com/simsong/tcpflow"
  url "https://digitalcorpora.org/downloads/tcpflow/tcpflow-1.4.5.tar.gz"
  sha256 "f39fed437911b858c97937bc902f68f9a690753617abe825411a8483a7f70c72"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2a96db945621f44af97ddbc01ee4883a78fc16fdb24804f6a601aa2add0044e9" => :high_sierra
    sha256 "fd7778c3e0b0c97983caba1860d2cd326a9c18663a4a730502256319360a8823" => :sierra
    sha256 "0905c5f721db6c6703967f9c05246b1dee95db680dd7d6c65bae09016d526beb" => :el_capitan
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

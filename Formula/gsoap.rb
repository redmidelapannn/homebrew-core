class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.cs.fsu.edu/~engelen/soap.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_2.8.28.zip"
  sha256 "453b36d97a98b35c2829284219dd09a4d60f073a5b77c658c403961c54cfa328"

  bottle do
    revision 1
    sha256 "faee4b671603377a134533dc079eef9e812292bd5d2b80dd7795b3a618e298e8" => :el_capitan
    sha256 "a5bf22cbbf7b60cd2e6ed3bd0bc1b5b2d5ae5a8e2ff98e60e82f58ec593f771e" => :yosemite
    sha256 "041603e6741cd35be6f5ddd4ff2da8fe3dbdd912cb96c83059c2ba02a1429ba1" => :mavericks
  end

  depends_on "openssl"

  def install
    ENV.deparallelize

    # OS X defines "TCP_FASTOPE" in netinet/tcp.h but doesn't
    # seems to recognise or accept "SOL_TCP". IPPROTO_TCP is equivalent, apparently.
    # https://github.com/Homebrew/homebrew/issues/44018#issuecomment-145231029
    inreplace "gsoap/stdsoap2.c", "SOL_TCP", "IPPROTO_TCP"
    inreplace "gsoap/stdsoap2.cpp", "SOL_TCP", "IPPROTO_TCP"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert File.exist?("calc.add.req.xml")
  end
end

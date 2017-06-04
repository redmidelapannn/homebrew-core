class Alpine < Formula
  desc "News and email agent"
  homepage "http://alpine.freeiz.com/alpine/"
  url "http://alpine.freeiz.com/alpine/release/src/alpine-2.21.tar.xz"
  sha256 "6030b6881b8168546756ab3a5e43628d8d564539b0476578e287775573a77438"

  bottle do
    rebuild 1
    sha256 "9d57cf3f6931f59b8d2b62c18cf6fe0bd1abcb50cae45a3a175bf3e02905fe25" => :sierra
    sha256 "b7958b565cfcb77ebbe47e751d418c91c06c1a68efd6aee1926f62959feb38ae" => :el_capitan
    sha256 "d9dada36751b17c843cee4cb2f15b58f6fcd42c3eab7f9d6d944066373f73d2a" => :yosemite
  end

  depends_on "openssl"

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end

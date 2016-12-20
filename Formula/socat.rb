class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.1.tar.gz"
  sha256 "a8cb07b12bcd04c98f4ffc1c68b79547f5dd4e23ddccb132940f6d55565c7f79"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "1ad65d574df54cec1d62e0789a02202a67b2be4a3c10cea2dbfccfdf072b7b21" => :sierra
    sha256 "736c87588faf4ac932bf4116e9dffdf51d0cbb54e98422f97a7a4172b1a5a79f" => :el_capitan
    sha256 "77e33538065e88f36abd68b96ff93f06aafad9ea2fc505becf6a2531f3038386" => :yosemite
  end

  devel do
    url "http://www.dest-unreach.org/socat/download/socat-2.0.0-b9.tar.gz"
    version "2.0.0-b9"
    sha256 "f9496ea44898d7707507a728f1ff16b887c80ada63f6d9abb0b727e96d5c281a"
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end

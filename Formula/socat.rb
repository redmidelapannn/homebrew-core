class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.2.tar.gz"
  sha256 "ce3efc17e3e544876ebce7cd6c85b3c279fda057b2857fcaaf67b9ab8bdaf034"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e2e201b4e6557ad10849759a16e6246e50a90a8890b96cdca64d066b1aaa436b" => :high_sierra
    sha256 "d54a2234c1bda87b80dda4e2cc67831b3447c0b23ebcb641ebee309feee852db" => :sierra
    sha256 "db5b042c9b996bd5b7dbbf1f7ed352110930430d8905493f21815242fac589f9" => :el_capitan
  end

  patch :p0 do
    url "https://bz-attachments.freebsd.org/attachment.cgi?id=154044"
    sha256 "fec773989fd298e53f3d91189253f79d7f23b78ce342b98cd3fd74d8e848b278"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end

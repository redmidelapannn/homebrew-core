class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.1.tar.gz"
  sha256 "a8cb07b12bcd04c98f4ffc1c68b79547f5dd4e23ddccb132940f6d55565c7f79"

  bottle do
    cellar :any
    rebuild 1
    sha256 "802add25d35e327fef62ceb5ca9a9cfe28657d0e4621b4e22d9733b7aa8afe9a" => :sierra
    sha256 "dfcd7e762f53ffb859e5585b2c731e40b015134f002ec0e513f7947b03ee00ee" => :el_capitan
    sha256 "b81038bb6633d65551c21d1a67250388a3c370e4f28760c055dacef06b576c32" => :yosemite
  end

  devel do
    url "http://www.dest-unreach.org/socat/download/socat-2.0.0-b9.tar.gz"
    version "2.0.0-b9"
    sha256 "f9496ea44898d7707507a728f1ff16b887c80ada63f6d9abb0b727e96d5c281a"
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end

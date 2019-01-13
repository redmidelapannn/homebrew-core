class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.8.tar.gz"
  sha256 "60481274403c551f5b717599c813d619877a009832c4a8a84fcead18e39382fa"

  bottle do
    cellar :any
    sha256 "014b2abd2327d1b3c012a1ff10a41eea12ef8f9fdc94f6348b8cab38efbcbd50" => :mojave
    sha256 "0f51b0cba061137c2b8d8981ccf3d1a9ee9efc041cca4eb8fb3770249f1a1fbe" => :high_sierra
    sha256 "76792e3c36321cc4640ab883f8aab5d7031a6fd6350d3fa60e75c4d9d80e2004" => :sierra
  end

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    require "socket"
    begin
      server = TCPServer.new(0)
      port = server.addr[1]
      accept_pid = fork do
        msg = server.accept.gets
        assert_match "SSH", msg
      end
      hss_read, hss_write = IO.pipe
      hss_pid = fork do
        exec "#{bin}/hss", "-H", "-p #{port} 127.0.0.1", "-u", "root", "true",
          :out => hss_write
      end
      server.close
      msg = hss_read.gets
      assert_match "Connection closed by remote host", msg
    ensure
      Process.kill("TERM", accept_pid)
      Process.kill("TERM", hss_pid)
    end
  end
end

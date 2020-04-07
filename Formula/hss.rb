class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.8.tar.gz"
  sha256 "60481274403c551f5b717599c813d619877a009832c4a8a84fcead18e39382fa"

  bottle do
    cellar :any
    rebuild 1
    sha256 "117d8576734ad73f8c8d2d14ca39af7e3bf540202db296891bb6d78131d722b2" => :catalina
    sha256 "97ce2163d13ca9a126feed78148e85b9e7f3ecaf794038fc629edfd940d4b314" => :mojave
    sha256 "479d8f5fd5ca953af2802f10014d2eba6deabc0597a517058dc1cfcde4ec97c8" => :high_sierra
  end

  depends_on "readline"

  def install
    system "make"
    system "make", "install", "INSTALL_BIN=#{bin}"
  end

  test do
    port = free_port
    begin
      server = TCPServer.new(port)
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

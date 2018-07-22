class Hss < Formula
  desc "Interactive parallel SSH client"
  homepage "https://github.com/six-ddc/hss"
  url "https://github.com/six-ddc/hss/archive/1.7.tar.gz"
  sha256 "99371c15fde236c806f7b6ed21b12bafc4f559fcbb636e0ab2112b09faa0e44a"

  bottle do
    cellar :any
    sha256 "95b08d83860d1461224cf9994add1a73bed77abaa6fda2b51edfbd7def8837f4" => :high_sierra
    sha256 "11bc2d0281ae697987202009db537e0c8a404ce9a6829e5a24420414d89da920" => :sierra
    sha256 "bc824089b12797ff9135682eca72591271e57615a3f9cf1de3b1a908e98ae611" => :el_capitan
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

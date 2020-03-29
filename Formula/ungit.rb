require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.6.tgz"
  sha256 "f105bcd9db7d498a7c472e807836820dca3a86ffc06ba5207e9c28f50761222b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b152ea8aadeaeba8687cc1332c30ca6a26a577311b2bd55090979136a00fdf2" => :catalina
    sha256 "d1b0626b4d6b0fabd517248b11785a12098558376c4ce2b9cc13bd5b8f7d3525" => :mojave
    sha256 "9013923f514f71ddef711be06200790b882cba42c67e228cd6eb188d49880257" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    ppid = fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}", "--autoShutdownTimeout=6000"
    end
    sleep 5
    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  ensure
    if ppid
      Process.kill("TERM", ppid)
      # ensure that there are no spawned child processes left
      child_p = pipe_output("ps -o pid,ppid").scan(/^(\d+)\s+#{ppid}\s*$/).map { |p| p[0].to_i }
      child_p.each { |pid| Process.kill("TERM", pid) }
      Process.wait(ppid)
    end
  end
end

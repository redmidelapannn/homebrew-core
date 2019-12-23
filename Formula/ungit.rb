require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.1.tgz"
  sha256 "8f045f6f606e3e89a8a053f86c9d403ba85df8d047e85a31a321fcce99cd9dee"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6bb13a9866b0f7ca19949855a14b53754be73627fc9cac85e68a0d6e2214c1cd" => :catalina
    sha256 "5d19239de960d9a0f1dda1ed85b9f6f5069431cac911ffd5759a447eb2667e26" => :mojave
    sha256 "36ad94c76a2117ae221ecc81004ea20e8916ca2f4b4e483a730544d7a03f66fa" => :high_sierra
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
      child_p = shell_output("ps -o pid,ppid").scan(/^(\d+)\s+#{ppid}\s*$/).map { |p| p[0].to_i }
      child_p.each { |pid| Process.kill("TERM", pid) }
      Process.wait(ppid)
    end
  end
end

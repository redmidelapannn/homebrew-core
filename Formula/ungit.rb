require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.3.tgz"
  sha256 "7c6308bd48b628f831c7c3f8579d2ece920dedb124fcf7390378256950e123a1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d9898acee78f09585ee59f7aa0f5c9bb1f19e1263f7cf0116289cfe1e34f847d" => :catalina
    sha256 "2121fab20dc991d876bd856c29375f655b844c9e1c72908c0acab5f9037cb1fd" => :mojave
    sha256 "67de16b2f3ff9da0172731d41ba6859ff1f10b746ab8c583a8266cc93e266910" => :high_sierra
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

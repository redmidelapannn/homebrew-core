require "language/node"

class Ungit < Formula
  desc "The easiest way to use git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.6.tgz"
  sha256 "f105bcd9db7d498a7c472e807836820dca3a86ffc06ba5207e9c28f50761222b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0b043b56fd582c734b726d711e7c84efc570c787915c9ccab9971e5832721087" => :catalina
    sha256 "37fe583ae197f5f58ea6856d4fed01c6d22eb5fdc5918ac9f3c12b8cfc0cec71" => :mojave
    sha256 "22a948a97417c0b2c45e0e43acaad3bbd7fa586eb0720927254831737fc467d2" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
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

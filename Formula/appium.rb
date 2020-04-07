require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.17.0.tgz"
  sha256 "62daf1dd25ef284db26d6c5b99a8f46dc6c5b8c01730a2bd4e8c87322324772d"
  head "https://github.com/appium/appium.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1e01548eee9d47a9bd10d2e11c38b003a23297d459d1a75cd52a5a0ef55fde73" => :catalina
    sha256 "0376721f12707c488768379f2279eb9b2c76f1673a04e50143c5a3be366261c1" => :mojave
    sha256 "c715989628a43c9349d6d7ad90bcfd391999af5445b376c5217c1ebfd420d0a3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appium --show-config 2>&1")
    assert_match version.to_str, output

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "The URL '/' did not map to a valid resource", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

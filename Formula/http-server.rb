require "language/node"

class HttpServer < Formula
  desc "Simple zero-configuration command-line HTTP server"
  homepage "https://github.com/http-party/http-server"
  url "https://registry.npmjs.org/http-server/-/http-server-0.12.1.tgz"
  sha256 "9d8ef9f4bd6fb76f4399e3fe725ab06a6a683bb82ec5799d6521fdcaa2c0def0"
  head "https://github.com/http-party/http-server.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "67d6514de92ff0b976dd80f3cceb235d4bd929319f02ac5f5f5118c88bd70174" => :catalina
    sha256 "570cce1ba1c01cec882db141cc4be1be511ddd2d46ed65df98b541a8a9e089ac" => :mojave
    sha256 "0d910eaa626ca99af283e43ce18094583c1f972486a74cdd3bddb69ab32c774f" => :high_sierra
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

    pid = fork do
      exec "#{bin}/http-server", "-p#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match /200 OK/m, output
  ensure
    Process.kill("HUP", pid)
  end
end

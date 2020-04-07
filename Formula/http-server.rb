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
    sha256 "53c243532ab2055a14f0a9a1a1a532d2f0629d5bb72ec5a75d9bf523133c6d32" => :catalina
    sha256 "6fbafcaf09ea5a2540005da9da06ea3961ed6464bf1918e2d9d457d8b6def08b" => :mojave
    sha256 "657a36cb6b31801fa9af9f950d14cf20307932037308818048815b71484381db" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

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

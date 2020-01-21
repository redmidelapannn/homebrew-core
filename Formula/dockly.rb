require "language/node"

class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.14.4.tgz"
  sha256 "6c24f868e063693c3274ce6f3219bbc852bde7b9532235ac1463fe3698b75c16"

  bottle do
    cellar :any_skip_relocation
    sha256 "4229ff8abc9e45330f82f919e4120740032a1a415a66d97e4fbca00aa207a6c9" => :catalina
    sha256 "eedb4738d830cb3cb7b6f6dfeb553fe49c0710561a6d9e820d15695152871a6d" => :mojave
    sha256 "ee85d6a2dd32810293a741bd625dae22fc4b49f13b30df265a50728219833935" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "--containerFilters string   Filter containers", shell_output("#{bin}/dockly --help 2>&1")

    assert_match "ECONNREFUSED /var/run/docker.sock", shell_output("#{bin}/dockly --containerFilters=\"name=test&status=running\" 2>&1", 255)
  end
end

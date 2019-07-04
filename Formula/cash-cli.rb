require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-3.1.2.tgz"
  sha256 "8c9875d60fc4d3b5cb1a9dda182b53c42b4ccb574f83317e51e9f608e1106fe3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4876a81ba7adccfd423640db81ed651224afe381a77625bb53beeb7159b82083" => :mojave
    sha256 "90a9bdfcd4ba3b4de4d00af822a1d8c228b08c6b09e3081ce046d4966bdba0eb" => :high_sierra
    sha256 "338ea5b9026a9208d0c1f6e10f9801850e1353d68fd2bde24c790f88336e9dcd" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Saved API key to", shell_output("#{bin}/cash --key foo")
  end
end

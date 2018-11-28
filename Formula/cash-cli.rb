require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-2.1.0.tgz"
  sha256 "8f2d484c2966c2fb4da9b7a8b4433a923990b6d8701b5eb7787f0c81954334c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "716b8bb99fc3cd032dde2fd127b020efa79734574d280b2c39dc0fa1db383ab9" => :mojave
    sha256 "3642cb8822a71c9392de8fa264a90856a2b7dc4a179ecb546fec9ab69bfb723b" => :high_sierra
    sha256 "1cab282bc155b0a6f6ea656d7baa2bb6ca2b577aa990d8f222134e521521afb3" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Conversion of INR 100", shell_output("#{bin}/cash 100 INR USD GBP")
  end
end

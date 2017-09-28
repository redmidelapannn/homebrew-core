require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-0.1.5.tgz"
  sha256 "133dcb72876b20a964f4a757ee647868bff1c34327e06e01c6cb80c8c18ff65c"
  head "https://github.com/aksakalli/gtop.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "703c0febbfe71a43b220dd3c9fca9c748c0a931a975e5bf4cf2cd3f295ef067e" => :high_sierra
    sha256 "b69ab054f04b540213a78b9db8a24e4ec91d30b11a6eedf4d75d7349649b40f1" => :sierra
    sha256 "b79b31a95200e74674d777c2117a844bbb7b641de6a69dbd6090f0e2fd808d0c" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

end

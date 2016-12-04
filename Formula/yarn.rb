require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://github.com/yarnpkg/yarn/archive/v0.18.0.tar.gz"
  sha256 "ce66a3ba519cc9293a21f12d455a1d575d8d95fa20bd659e4a15e0e41224e342"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc690eddf85f63e1e99b460d823382a0d69e217a65b307b01700a6f4ac34f059" => :sierra
    sha256 "9c8b5d88948506402c165c45bf7e4efb11d3c3f14d85599f76d43c3a2062d58d" => :el_capitan
    sha256 "226fe1e83ec3515b542ca504584d7cb2a216d878f284f31a659fd0c86a2e383b" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end

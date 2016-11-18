require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.17.5/yarn-v0.17.5.tar.gz"
  sha256 "3dcd8718080aba7a14b78e1090db1abfbd154039a15cba803bb1578016250288"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdb48d1e8574255bfb3192aa97cef839caa81dc28d11e69fee8a63ef04448a65" => :sierra
    sha256 "2ad51407ee0bd8830f64e42be40315892f30150eae4daab653a9ac9898404b55" => :el_capitan
    sha256 "d825b525d85a4b27be95189b2604d5f935167521f98b237d5267ee0f6773ef75" => :yosemite
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

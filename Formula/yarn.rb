require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.1/yarn-v0.21.1.tar.gz"
  sha256 "20efb92efc66631b10f4e6ab9b1e8b6773d6729baa5ade963030fd66badf3bb6"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd6e48b6c951d5e0cadd751cbfa8fada058440686c86b922a5cbfdf70b9d50a1" => :sierra
    sha256 "dc5f2ffd86e5ce8292ac0f5aecf09e257426bcc8f3960ce36d9d4ea3bd4d4e36" => :el_capitan
    sha256 "425800ca6244908784ffbdf76019eefeb13dceb3eb1725d057bb89c5ad3c33a1" => :yosemite
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

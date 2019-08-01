require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.22.tgz"
  sha256 "ba596d246d288f1ef9312345c9f7bc9e5b1d21c487a73c3d41bd54e6dd48e368"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9eb101c9e6b41165d365f6688cc13b06cec870579c58598ea2ef8a5318c1e09" => :mojave
    sha256 "93d0f854ca359a426333c95cf5d63845a59c4db17813c216f82a51adae943f5f" => :high_sierra
    sha256 "5035f83927551a107858732e027c145dc498e62cc48fab66d09dfa31db43b11d" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end

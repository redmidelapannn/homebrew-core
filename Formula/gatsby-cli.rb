require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.18.tgz"
  sha256 "b4e492eee86d3fe9a0aef65a34317e8df8a900626c29cd9d57c4d1105e86bb03"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6c901605d464c11736c94a592a4700298262a389a9f7277955e31f6874e7f07" => :mojave
    sha256 "5b75cf909e11b9ee3c2d153d4c879c674517a392b30b876d64c656a6de47f9bd" => :high_sierra
    sha256 "9c36cbe435bbd79750723cad782f3e70c03b4bd184eddef47432025024c158d7" => :sierra
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

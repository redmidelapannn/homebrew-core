require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.5.tgz"
  sha256 "c1d3c6ed18d58fa463db20ae062ab0750e7887122321474cf9166aadf0e435a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8c694bff0b977fe5e01f541688bd0a9862159b04bcca3dd8fc3b48d3c5a0ef9" => :catalina
    sha256 "bd9a618cfd2f75c6c76ef24eefc07f574d81c7114f9a093bf3c5875b20a1cc78" => :mojave
    sha256 "89177a92c85e90ee76085974da5f44b63cc8802dcea88ae8bd138289a44e50bf" => :high_sierra
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

require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.31.tgz"
  sha256 "1a567867f99e628c3308b535ce2dbe61881a35a2c6d0b7bebe936b8c3179962b"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af759428e5d817a9724876c528246eb1e965fc685c2234dad7b355ff627aee51" => :catalina
    sha256 "4063eb879707d87fb2b873b8a4e3f56f10bf12f9f24b768226f2d126b8a65956" => :mojave
    sha256 "3d2ea030b8d9cd5b87946e26b1ea9087439a3a5ccf4a2116871dbf32da30c1e7" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end

require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-0.36.1.tgz"
  sha256 "96bf2ac01eb7c4aa85f0fc1a0fa0fdce49409ffb99a52827c1268d3bb92b089e"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf6573c3fd63c0161e3fd035e3b331ed1b08eb183ac9f6ccfab24c26059eaed3" => :mojave
    sha256 "6c4947c9c71feddd5f44b8cbd6f5735c7545564e93fd1575174b5fbd868a9385" => :high_sierra
    sha256 "f8f164596fcba2bfdeef07a874c3c4ff80ac8eee92744757eecf567c71835be2" => :sierra
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

require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.12.tgz"
  sha256 "e7dfbf608ba66c2c8c1b15dd0b1da51f655ca5720e497f5db34b1e136f16a3fc"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b43d34d8c030bb9bd48240f49b64a0225f227c2fd115990f8ed1bc96b031e111" => :catalina
    sha256 "21bf8f96189f32c2163b4c358a567c2eac5b925e3a3df140b388264f06624614" => :mojave
    sha256 "b1c1eaada7f4afe46a951d485a7f79f6c0b5388bdaa3d92064f405bba661ce6d" => :high_sierra
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

require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.14.tgz"
  sha256 "0bc3fc71440fa52cf92ae4841a07d2248e0be4c52d420623bc1dac6ff3cd7097"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f11c922f0a8b2ae1adde564f9d2cc6e0172b15cb2cade46e03baa30f62e95d07" => :catalina
    sha256 "c3613adbe0b29d7fdc9c20aa8ec2aa2928e586073c061b468130ef996ce0b98e" => :mojave
    sha256 "a882d221a852337c4cce4a1acb6cd7da481c7147d25807217c24406f850ff1c8" => :high_sierra
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

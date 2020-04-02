require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.28.tgz"
  sha256 "e26eccf1771084ffe540615baa88cf325a53730dab0dc732855ed6b11054afff"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8661162c10389cf6a7a595bb031f632dcfa5fe0369dd9aaafbd6f0996e99c83" => :catalina
    sha256 "6e8b6d9f5743d1afd2ee6b6e0b429879d89fa6cc4a2d8bc1eb53cf77e86fe6bc" => :mojave
    sha256 "4b0d96902f35196065c83d95ee9072ae9d7ee4410f3057341c30544409736192" => :high_sierra
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

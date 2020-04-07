require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.8.tgz"
  sha256 "05093e07f9dc3ddbd104b3c88eee9618fc1ba5885bc739940a9c989a7a73d45a"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f11b25c770a166091ad03dbe7580fa6d66addc048e89c06a70e21f5b610944a1" => :catalina
    sha256 "6161d846b17e373c4475dc04691c8046e6582c3306e7217934c5c56d5e2a1a2c" => :mojave
    sha256 "a366d96fb83bb897165f67781c72c408ad26e9dd6e7dcf954537d044d5f01e22" => :high_sierra
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

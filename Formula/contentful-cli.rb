require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.13.tgz"
  sha256 "8f693a8d91c50467b2566c01013b455bf9299c392e00dd218dad3f2942e36449"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef8f6143d8b9f18834c6f6f17ef2281074942514dad32158df11dba4b6ad01ec" => :catalina
    sha256 "20589a7c0646ed395402b409b4adb71d876ecaccc3870f2a07a503883c508a49" => :mojave
    sha256 "d83aa7a2ff1f99aa35123dc1465c51c3ce28a258a75105755d5322e12ea91b2c" => :high_sierra
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

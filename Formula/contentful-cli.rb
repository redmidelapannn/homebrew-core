require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.15.tgz"
  sha256 "18785482cc0dfbd9c1d8aed90ba8bafa076de3a2a4cf02041a2302025a0d30ce"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e4dd528b152916f92cd163b7c454ca21b350bfb8754c7b3892d9808da65e38b" => :catalina
    sha256 "58a79b799adc4cc0306d2ab76a9f9549139de441d6566b24e3949335f0e2381c" => :mojave
    sha256 "f96d1f16a4713aec5510eb9687de7ade90c239f5398a7afc52b67503eca9993a" => :high_sierra
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

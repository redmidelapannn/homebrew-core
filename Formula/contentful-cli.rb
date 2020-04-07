require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.2.tgz"
  sha256 "6ce7137a14605fac5e3a69e60ad738a3c73856a14f32e3deb6c7980c4af2f345"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "989553225e4b5d0e2627b1b6c343900964aa1225021f1ce82530a7de4e88d0e7" => :catalina
    sha256 "867a5a62c155d74110bfaafe55b763c71773481adb38f95237cb9033d3bb7003" => :mojave
    sha256 "b54154e1c229e5f2023158dbb33f6e764684ba0d7a16e657de7abc33c91fd333" => :high_sierra
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

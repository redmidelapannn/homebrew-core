require "language/node"

class ApolloCli < Formula
  desc "Tooling for development and production Apollo workflows"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.17.3.tgz"
  sha256 "1fd8c82904e3b70a7133ce30f29545e707468809c6b2cef477836ef1afcd2d2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "30930ae539e86f07e90495feac68c18b4c8780b3bab5ed86396362c917636685" => :mojave
    sha256 "03077f56302ddad46232e9f455bd89de0b816b58b67cf3c0493eb72a637a562b" => :high_sierra
    sha256 "caacb215ab0a862c9f3302ef4f9bcb3dc3ea645799bb38cc72603b28477f485c" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apollo --version")
    assert_match /apollo/, shell_output("#{bin}/apollo help")
  end
end

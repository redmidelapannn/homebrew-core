require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.26.0.tgz"
  sha256 "a23097b1d1507b51c3a1f8eb461368520df22fa51390210ca1e7f0055aa0842f"

  bottle do
    cellar :any_skip_relocation
    sha256 "30b0001c417c1fc5a2647df69a89c2c50b3e28aaa0912d1f1aebe95fe843508b" => :catalina
    sha256 "f51bb3e8c6fa930de415aa0842574810a21644655969aef404ac9f599e0bb212" => :mojave
    sha256 "dbb02394e42db0889865caac12a5872a4f34906a0f272206a54179c016c728af" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Please add either a client or service config", error_output
  end
end

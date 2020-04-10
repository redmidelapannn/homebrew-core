require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.30.17.tgz"
  sha256 "982ae07ff72c6882a01943f3514be7dfb3ea55f4261f9aeae8468d14b5c4f1db"

  bottle do
    sha256 "cb7a8d6f82d6044a683e3f548fcb2851a27db49b37454454c59fe0e91ff5fcab" => :catalina
    sha256 "adc126977ee4fbd66d7afb3bd9af9067dca19e68b01b8268c48ef2c95bf79c9b" => :mojave
    sha256 "5574cff3f1a9a3c6b1c15023211733ce14812086b2235a84bcb148b23b1d26b9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end

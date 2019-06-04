require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-10.17.4.tgz"
  sha256 "3342c68d1824c419ff27dc6a7d7688ae4dd1f1715c8571ed73b964c299c491b8"

  bottle do
    sha256 "1ea40285d7985256e84e0aaa6e6de9548a5f1e362589afc504b8d3a0e27df26d" => :mojave
    sha256 "5e33774bd05183e007b118081436e2222f2c64e6768034dfb63a26c05c8b6e4f" => :high_sierra
    sha256 "ad1b18a8dae1ced580070928382558688c5edbdba7a26ed645c5bf8f5109f006" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
    assert_match "Logging in to balena-cloud.com", output
  end
end

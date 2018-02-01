require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.15.21.tgz"
  sha256 "d5a1f28a5763ed8cf750d961f8868e3fffe3506c81244a6b1161c231cda63e27"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45ab46b36ee6df211f6b51833a5893116b4f4e37feb2c3680fe33b25d34a26de" => :high_sierra
    sha256 "092a021645c967699fd308e21a5d4c2ac000881a7dcd7106ad08ea50dbd45b50" => :sierra
    sha256 "193f61fbf7d3ef1c9dc85e502e8e738e0694ab2152d4f99e7e9f8842462170bb" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run" do |s|
      s.gsub! "npm update -g heroku-cli", "brew upgrade heroku"
      s.gsub! "#!/usr/bin/env node", "#!#{Formula["node"].opt_bin}/node"
    end
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end

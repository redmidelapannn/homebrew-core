require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.34.tgz"
  sha256 "b37f29699aa4d29d5b8ce0db2c8b06ad73ed3127b330897131bd79b8429dd4b2"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "595c8ebac39efdc5c49f8b49a8bc3f5a70d574c3736da8976b07e5e75ebf056d" => :high_sierra
    sha256 "2e5155b904ead994a0ec76deae7b9b96a004567bbc8e3654742938e1fbc4f6a8" => :sierra
    sha256 "384287a9df8e5f553a24f6de7d32cc69fb40c394ffac7f57d22471c0f22ad28b" => :el_capitan
  end

  depends_on "node" => :recommended

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

require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.14.0.tgz"
  sha256 "74b2d90c10849e2c0f0987be56a0b153374501b654973a82d74adebe7a16dd36"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "190867267df06367ab8bd3cfcf5b9bf0e9261321747a3c40708631f959d0398e" => :sierra
    sha256 "31e3731d46c9e8f35e0cbe392165d0a2f8250ec2c7be15a6d1c49707ba56d1e0" => :el_capitan
    sha256 "cdb04a12ae898fe1f6e37d5968eb927f4418545028afe08c69a3d24f70d69433" => :yosemite
  end

  depends_on "node"

  def install
    inreplace "bin/run.js", "npm update -g heroku-cli", "brew upgrade heroku"
    inreplace "bin/run", "node \"$DIR/run.js\"",
                         "#{Formula["node"].opt_bin}/node \"$DIR/run.js\""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end

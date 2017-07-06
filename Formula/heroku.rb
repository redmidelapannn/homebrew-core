require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.5.tgz"
  version "6.12.5"
  sha256 "941320b806922a4e9d9035844991f28458ae7e52c32080162d26f4c947aa2636"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba5ab51debb5d39c65724da7485974f463c2d113347159228893da292c6f02a0" => :sierra
    sha256 "dec5ad8931884c1ec9cdd7f84f26ab26cded3c1ba44f3b502ec699b53b27e039" => :el_capitan
    sha256 "a8554e5d8bb147576f1661347122eaf770fb807735bb5450ab9920c462fc6bb8" => :yosemite
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

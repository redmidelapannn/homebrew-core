require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.12.5.tgz"
  sha256 "941320b806922a4e9d9035844991f28458ae7e52c32080162d26f4c947aa2636"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d4cb83946f00fe948f28c80b7b9a2a699b9ebc866a823a8cf84a92d8dcf84307" => :sierra
    sha256 "5f1b580dd8020730a048fc71cc49e3e4ae4006b2997d313dd4d5357c6ca671ee" => :el_capitan
    sha256 "c20bae22498774ae155985f62dc740fea7407f6cb84274ef08646b23dc5514aa" => :yosemite
  end

  depends_on "node@8"

  def install
    inreplace "bin/run.js", "npm update -g heroku-cli", "brew upgrade heroku"
    inreplace "bin/run", "node \"$DIR/run.js\"",
                         "#{Formula["node@8"].opt_bin}/node \"$DIR/run.js\""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end

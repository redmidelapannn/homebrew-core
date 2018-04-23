require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku-cli/-/heroku-cli-6.16.18.tgz"
  sha256 "67cdbda1f19ed9829f656b3611f480401ccad30260dd060bdc1784dc4460edf9"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35569c980a0240cebea0203797ec6fec7c9f90fec5a36b3a8897b66c254d332c" => :high_sierra
    sha256 "eaa338948e3853d4d3d50e6ff47a5a0b2129c083d922380706949f0e0c4ad169" => :sierra
    sha256 "3d8988245cdf544d9fd9582dd24c97ff0cfaadf6a59c46fad97109d390300502" => :el_capitan
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

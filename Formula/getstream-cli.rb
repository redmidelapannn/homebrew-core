require "language/node"

class GetstreamCli < Formula
  desc "A carefully crafted CLI for managing Stream applications directly from the command line. 🚀"
  homepage "https://github.com/GetStream/stream-cli/blob/master/README.md"
  url "https://registry.npmjs.org/getstream-cli/-/getstream-cli-0.0.1-beta.58.tgz"
  version "0.0.1-beta.58"
  sha256 "3a976e56dd976baf071bcd4c9478b1c2ff67fa55010fb89dddbbbde49df95eea"

  bottle do
    cellar :any_skip_relocation
    sha256 "a716dc041f5d7592281d8c7382332d736d1bd8eed422d3f66a024fb6c1e999e5" => :mojave
    sha256 "6f80433ad1892885908082d2a03c8fc0c55e75b1e6c860b37f510895f2623fd8" => :high_sierra
    sha256 "2674f37478d1d65f4c4c55faab370d7883446af1f389b28c24f13eccf5f4801b" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    raise "Test not implemented."
  end
end
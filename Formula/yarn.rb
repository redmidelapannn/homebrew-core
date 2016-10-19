require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.16.0/yarn-v0.16.0.tar.gz"
  sha256 "cd1d7eeb8eb2518441d99c914e5fd18b68e2759743d212dfd8f00574a1de6da8"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fddc7d56b62df958b9483f42d277ae386cd1f59fd6e45090080533de782fb831" => :sierra
    sha256 "4ee773248421331ebd889f48181ed2b852edfdb63474d0fbf14d6d738b3dd2a2" => :el_capitan
    sha256 "e4278045bc99ef76fcf310f86e1624d9e7cd2ececb48e2f0709de3d1c8e7caed" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end

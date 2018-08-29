require "language/node"

class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/"
  url "https://github.com/resin-io/etcher/archive/v1.4.4.tar.gz"
  sha256 "02082bc1caac746e1cdcd95c2892c9b41ff8d45a672b52f8467548cad4850f5d"

  bottle do
    sha256 "90488f77093e9b43c0e57ae0a18b35fa08e4bec51aba67d2ae0e600771bb9b1c" => :high_sierra
    sha256 "b78d1372e60919891d7349e16a6217af3fc988cc2bde824e2716c47cd122442a" => :sierra
    sha256 "d803153d15c61ee9eb54d2d7093b4a5e9ca0faa66382f0006ee354926477fd8b" => :el_capitan
  end

  depends_on "node@6" => :build # must be abi compatiable to the node version used with pkg
  depends_on "python" => :build

  def install
    rm "npm-shrinkwrap.json"
    system "npm", "install", "--production", *Language::Node.local_npm_install_args
    system "npm", "install", *Language::Node.local_npm_install_args, "pkg@4.3.0", "--prefix=#{buildpath}/pkg"

    system buildpath/"pkg/node_modules/.bin/pkg", "--output", libexec/"etcher", "--build",
           "-t", "node6-macos-x64", "--debug", "lib/cli/etcher.js"
    system buildpath/"scripts/build/dependencies-npm-extract-addons.sh",
           "-d", buildpath/"node_modules", "-o", libexec/"node_modules"

    bin.install_symlink libexec/"etcher"
  end

  test do
    assert_equal pipe_output("#{bin}/etcher --version").chomp, "1.4.4"
  end
end

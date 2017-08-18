require "language/node"

class Scolan < Formula
  desc "Sync clipboard over LAN"
  homepage "https://github.com/Cap32/scolan"
  url "https://registry.npmjs.org/scolan/-/scolan-0.0.0.tgz"
  # version "0.0.0"
  sha256 "09da31c47ff34e2f097ebc428995da0adae4eee95ec4c2da8096ed75d1e639cb"

  bottle do
    sha256 "c21e2d8c51f767a1faa480c30a910d5e57d2e97b6d200a8e7a67cded6df8c998" => :sierra
    sha256 "34f8acef04dd411d0f4359ffc85295c63b98cb9ef6419b3fd712a613482ade84" => :el_capitan
    sha256 "df2479bfbbce5fd8ee27e108add0b1bc438e9cf2d8a849d2fa93b5741ca9219f" => :yosemite
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

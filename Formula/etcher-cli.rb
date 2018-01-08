class EtcherCli < Formula
  desc "Flash OS images to SD cards & USB drives, safely and easily"
  homepage "https://etcher.io/"
  url "https://github.com/resin-io/etcher/releases/download/v1.2.1/Etcher-cli-1.2.1-darwin-x64.tar.gz"
  version "1.2.1"
  sha256 "18c20ace231bdb0b954d89946a98de25c869c918e7399e7fb7133486dd0eff55"

  bottle do
    sha256 "4bf526397afcba678a6e5c3f53526f9b4a94f0f03c25e3bf2d370d3718de4a20" => :sierra
    sha256 "4bf526397afcba678a6e5c3f53526f9b4a94f0f03c25e3bf2d370d3718de4a20" => :el_capitan
  end

  def install
    prefix.install Dir["node_modules/*"]
    bin.install "etcher"
  end

  test do
    assert_equal "1.2.1", shell_output("#{bin/etcher} -v").strip
  end
end

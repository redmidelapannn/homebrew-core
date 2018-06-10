class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.20.1.tar.gz"
  sha256 "0bee8be4841147528c41417e4eb1f44eaddd7aa16b267d6237ec2abafecf71b2"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    rebuild 1
    sha256 "6926f8ba82199759049a367dd0658dba9be9d63eab919e2c42b384593a1511a8" => :high_sierra
    sha256 "f485267f7d2eebfeb6749adf9457f905442687a18411cafe5ef5bdefadb44953" => :sierra
    sha256 "0d6defce824729f2a70f4ec65927fd535ba4782bb263f9ad834d17d819199e43" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    dir = build.head? ? "testing/geckodriver" : "."
    cd(dir) { system "cargo", "install", "--root", prefix }
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end

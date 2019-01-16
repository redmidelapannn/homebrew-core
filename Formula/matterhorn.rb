class Matterhorn < Formula
  desc "Unix terminal client for the Mattermost chat system"
  homepage "https://github.com/matterhorn-chat/matterhorn"
  url "https://github.com/matterhorn-chat/matterhorn/releases/download/50200.1.1/matterhorn-50200.1.1-Darwin-x86_64.tar.bz2"
  sha256 "3ae6a19ecd47eeddb303970e77d5fd5379a64eda3c9b430ec80c6fd6a6429705"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e774e110092bd32d698c97a4d1b71323d4e569af2ee44d654a0f1960250c02" => :mojave
    sha256 "759b5b1cf0ce904b06cf9b1e2d1097310248b555beef615ac69e2175d8bdc063" => :high_sierra
    sha256 "759b5b1cf0ce904b06cf9b1e2d1097310248b555beef615ac69e2175d8bdc063" => :sierra
  end

  def install
    bin.install "matterhorn"
  end

  test do
    system "#{bin}matterhorn", "--version"
  end
end

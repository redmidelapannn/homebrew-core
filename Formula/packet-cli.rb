require "language/go"

class PacketCli < Formula
  desc "Official Packet CLI [WIP]"
  homepage "https://packet.net"
  url "https://github.com/packethost/packet-cli/archive/0.0.2.tar.gz"
  sha256 "1312a9b40a8178e6c106efe887e886b46cf4ff90dd80597e7bc7e46059392e8f"
  bottle do
    cellar :any_skip_relocation
    sha256 "51bb48c5da1feae61d75f3ede04e1c589db9f455fd8b6e4e6978b605a259fe1f" => :mojave
    sha256 "ce5c8e52e73b387f990a930eb439dfd430034f9f20bb6dadd05493dd83468572" => :high_sierra
    sha256 "ad73359cdbdb340ec56820bbbaa28c649f5f83bdbcbb4b3e1dc765f1cb67be46" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/packethost/packet-cli"
    path.install Dir["*"]

    cd path do
      system "go", "build", "-o", "#{bin}/packet-cli"
    end
  end

  test do
    output = shell_output(bin/"packet-cli --version")
    assert_match "packet version #{version}", output
  end
end

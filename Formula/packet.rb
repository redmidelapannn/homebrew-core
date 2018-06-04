class Packet < Formula
  desc "CLI tool to manage packet.net services"
  homepage "https://github.com/ebsarr/packet"
  url "https://github.com/ebsarr/packet/raw/master/archive/packet-2.3.tar.gz"
  sha256 "eb6cf6c63933dd1b90e44df0569ecad09791596770ba720db292ecb442d6bc20"

  bottle do
    cellar :any_skip_relocation
    sha256 "e687ef3d05e452b1b4846c6f62364fad966abbc389c8aabb7cb207947efa5819" => :high_sierra
    sha256 "e687ef3d05e452b1b4846c6f62364fad966abbc389c8aabb7cb207947efa5819" => :sierra
    sha256 "e687ef3d05e452b1b4846c6f62364fad966abbc389c8aabb7cb207947efa5819" => :el_capitan
  end

  def install
    bin.install "packet"
  end

  test do
    `packet admin list-profiles`
    system "false"
  end
end

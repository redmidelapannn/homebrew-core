class Podcast < Formula
  desc "Command line podcast player"
  homepage "https://github.com/njaremko/podcast"
  url "https://github.com/njaremko/podcast/archive/0.12.1.tar.gz"
  sha256 "18e401751729c6844f43298c1da934fc6d1379da20cc4287ea4dee6ed6a26522"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c2b663909df10dd730b2dc0b707323696e8f680e52fafe2b048187a074db7c4" => :mojave
    sha256 "d27d2dec2fc568a55331460e84f02e66abde16fdb3d55d9fe05bbbdd5a61a6dc" => :high_sierra
    sha256 "a05908bfbb914a77cdd37da05a3c9dcd2669a24a1e42583e66f89ccff817c485" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/podcast", "subscribe", "http://feeds.feedburner.com/mbmbam"
    assert_match "My Brother, My Brother And Me",
                 shell_output("#{bin}/podcast", "ls")
  end
end

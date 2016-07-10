class Rainbarf < Formula
  desc "CPU/RAM/battery stats chart bar for tmux (and GNU screen)"
  homepage "https://github.com/creaktive/rainbarf"
  url "https://github.com/creaktive/rainbarf/archive/v1.3.tar.gz"
  sha256 "e2491e9f40f2822a416305a56e47228bd6bfc1688314ad5d8d8c702d4e79c578"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae98068809035445da813c9c5c140dddec5a9a0f02fbb621d16ce89458f7850e" => :el_capitan
    sha256 "72570a5c0fdcf9d3bfc509c0dcdadbb551f6b8ec8b786b7348114bce7544acfd" => :yosemite
    sha256 "9b3129bca9808be78ae05ed963e92f43eeebaa24445addc27c7dfe048a3d19ee" => :mavericks
  end

  def install
    system "pod2man", "rainbarf", "rainbarf.1"
    man1.install "rainbarf.1"
    bin.install "rainbarf"
  end

  test do
    system "#{bin}/rainbarf"
  end
end

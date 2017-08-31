class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-4.7.tar.gz"
  sha256 "a75635f8dc2cbc280deecb906ad9b7594c5c31620e4a01ba30dc83984881f7b9"

  head "https://git.suckless.org/dmenu/", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "13bde2c9bb2ab39d5c0c80065e2716402f5ee9a5850abc4e4cf9259abc8a8ae6" => :sierra
    sha256 "6308a752ea0d36309127f90aceb24a7a1d93e0138d3429e6986f031318be2a22" => :el_capitan
    sha256 "a793c5c3fd96c5ae31bf54287bfb008073bd48584223f870ad135a3fac8c9dc5" => :yosemite
  end

  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/dmenu -v")
  end
end

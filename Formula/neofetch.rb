class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/5.0.0.tar.gz"
  sha256 "2a4f4853bf83b88a037994dbc53a90c8bd5708f5eeb3392f56d4e49c49d995b3"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a68b6f5b96608b57623bb1140dad54b7a85f7a01153815fb11813c43a4206fe3" => :mojave
    sha256 "67bbec378c2b3dfeb333e7cec84a4566c6d5179b518a6d4fcfe42f8ef02a7d76" => :high_sierra
    sha256 "67bbec378c2b3dfeb333e7cec84a4566c6d5179b518a6d4fcfe42f8ef02a7d76" => :sierra
  end

  depends_on "imagemagick"
  depends_on "screenresolution"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end

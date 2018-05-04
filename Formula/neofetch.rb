class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.4.0.tar.gz"
  sha256 "2b03328e92f80de8aca9571ad693f4e8b86b62e9c99792f3002f82907c5530a3"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4f9ce26cd65f39bcc4858175511ab7c78c6ec07210d3997644e47e2c32fe880a" => :high_sierra
    sha256 "4f9ce26cd65f39bcc4858175511ab7c78c6ec07210d3997644e47e2c32fe880a" => :sierra
    sha256 "4f9ce26cd65f39bcc4858175511ab7c78c6ec07210d3997644e47e2c32fe880a" => :el_capitan
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    if build.head?
      bin.install "neofetch"
      man.install "neofetch.1"
    else
      system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}"
    end
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end

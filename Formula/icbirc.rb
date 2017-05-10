class Icbirc < Formula
  desc "Proxy IRC client and ICB server"
  homepage "https://www.benzedrine.ch/icbirc.html"
  url "https://www.benzedrine.ch/icbirc-2.0.tar.gz"
  sha256 "7607c7d80fc3939ccb913c9fcc57a63d3552af3615454e406ff0e3737c0ce6bd"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "73c4152bd71c47b920109923c9fd5f97328c920d14e8829f90c512d9dae2d5d1" => :sierra
    sha256 "6bd56de4a1960c61b334c052392eb5c78336d642065399d868b83878e49fc0e7" => :el_capitan
    sha256 "f07c7176cebf0ba8d74060c5573f9c81d105e81b60da3ab2ea2d48cd23732aa1" => :yosemite
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "icbirc"
    man8.install "icbirc.8"
  end
end

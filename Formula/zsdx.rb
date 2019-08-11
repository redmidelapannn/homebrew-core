class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-dx"
  url "https://gitlab.com/solarus-games/zsdx/-/archive/v1.12.1/zsdx-v1.12.1.tar.bz2"
  sha256 "5d336c83eab2dfcef77526f4b54d6e0846dc3e2d5a952dc62d8f9540de79a0cd"
  head "https://gitlab.com/solarus-games/zsdx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e8e8fe4971becca69605c7ad1976dbf6b1545eb440615f46be67493f208ff50" => :mojave
    sha256 "cedb7d9abec60eee0442fc520525dcc3100630aed0e557a4a83d0d68973d74f8" => :high_sierra
    sha256 "3609f875dd2a60590bb42ad77d5ef6d533b79f70a96ce955e84af13476be62b4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", pkgshare/"data.solarus"
  end
end

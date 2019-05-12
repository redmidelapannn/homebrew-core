class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "https://www.solarus-games.org/en/games/the-legend-of-zelda-mystery-of-solarus-dx"
  url "https://github.com/christopho/zsdx/archive/zsdx-1.11.0.tar.gz"
  sha256 "05a5d220bbf2439c9da2e71cd9d104240878123fff5bc702e2405d6d0712f0dc"
  head "https://github.com/christopho/zsdx.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6b366780abbf2cc5a876c11725704d1cb9ea40a9998d4523afcbd616eff92007" => :mojave
    sha256 "b7f5d7e8f69e65b8d70adbd8394c55c09a3ef36756dc8df286aa90cf1109c996" => :high_sierra
    sha256 "20796b3544e269abbc249a71ebae1050a83b6f6fb5e455f250ce6bf109f7bceb" => :sierra
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

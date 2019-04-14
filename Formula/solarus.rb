class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  head "https://github.com/christopho/solarus.git"

  stable do
    url "https://www.solarus-games.org/downloads/solarus/solarus-1.5.3-src.tar.gz"
    sha256 "7608f3bdc7baef36e95db5e4fa4c8c5be0a3f436c50c53ab72d70a92aa44cc1c"

    # Upstream patch for build issue, remove in next version
    # https://github.com/solarus-games/solarus/issues/1084
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e6a26f3d/solarus/config.patch"
      sha256 "7bb5c39dd97eca215a22a28dffe23dfac364252f7ff8221e5d76ae40d037be76"
    end
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "cd312d16c9652d6c807dc8c5ddecfe8c38a0d51e6510d9d58c7dbfe8d60939f6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  def install
    mkdir "build" do
      system "cmake", "..", "-DSOLARUS_GUI=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/solarus-run", "-help"
  end
end

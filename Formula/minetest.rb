class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/5.0.0.tar.gz"
    sha256 "1ba816f77dc9dbd5a4995f0c1d482f8f22b9aa75b6d6999dbfd1f3d698363d0a"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.0.0.tar.gz"
      sha256 "83688d802f9d8308acf6f95e6845cdbe1ee1bc088a963a30f94cf72ec7265cf8"
    end
  end

  bottle do
    sha256 "9808067d9b75c2b6e42f15e5f22b1b9811f0c71310203e4b9443a11320178d72" => :mojave
    sha256 "075751b8678e531812f4c4fb6526e0076765a3b842c26a801cafd70135e13b1d" => :high_sierra
    sha256 "1b71fb16381b7abff8cc15962c0008a8a3fd750393ffec7b48f5c632a2e7b221" => :sierra
  end

  head do
    url "https://github.com/minetest/minetest.git"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", :branch => "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "irrlicht"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"

  def install
    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release" << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
    args << "-DENABLE_FREETYPE=1" << "-DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'"
    args << "-DENABLE_GETTEXT=1" << "-DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}"

    # -ffast-math compiler flag is an issue on Mac
    # https://github.com/minetest/minetest/issues/4274
    inreplace "src/CMakeLists.txt", "-ffast-math", ""

    system "cmake", ".", *args
    system "make", "package"
    system "unzip", "minetest-*-osx.zip"
    prefix.install "minetest.app"
  end

  def caveats
    <<~EOS
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      If you would like to start the Minetest server from a terminal, run
      "/Applications/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end
    
  test do
    system "false"
  end
end

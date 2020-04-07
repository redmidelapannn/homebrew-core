class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/5.2.0.tar.gz"
    sha256 "4996c7c50a6600d0c7140680d4bd995cb9aae910f216b46373953b49d6b13a5d"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.2.0.tar.gz"
      sha256 "0c49fd6e310de1aba2e8cb8ae72efe0e06bb6bc8d7c5efea23bc201b6a80ce94"
    end
  end

  bottle do
    sha256 "2598306f55dad62f6bcd8715842b7231a55c36158be859f83e4305993259f258" => :catalina
    sha256 "e38d21f7250d21872bcda413a064c0c0def272cbaf3b6069a72dedbd418ab303" => :mojave
    sha256 "7d0181c71af1c2af4b6192cde8a1a51a9e255fb1e90420edc123a6be6dad9452" => :high_sierra
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
      "#{prefix}/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end

  test do
    system "#{prefix}/minetest.app/Contents/MacOS/minetest", "--version"
  end
end

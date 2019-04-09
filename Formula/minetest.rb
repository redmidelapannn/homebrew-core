class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/5.0.1.tar.gz"
    sha256 "aa771cf178ad1b436d5723e5d6dd24e42b5d56f1cfe9c930f6426b7f24bb1635"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.0.1.tar.gz"
      sha256 "965d2cf3ac8c822bc9e60fb8f508182fb2f24dde46f46b000caf225ebe2ec519"
    end
  end

  bottle do
    sha256 "30561149bd96b734f7c8476b78ba861121a2e31091e836c1ea78124dbd590a65" => :mojave
    sha256 "8452d8acd24057a38da8c4a79292cd28e29c852ab250c78b6ceb96ba32fa741a" => :high_sierra
    sha256 "87c872de4f1232468223e2dd1d37fb1e759bf663d39cb11a011dc12c2d4e1a0a" => :sierra
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
    #
    # --help and --version produce output directly.
    # --videomodes need user data directory in order to work.
    # --info and --trace need user data directory and will actually run the game.
    #
    # --run-unittests and --speedtests do not work for Homebrew
    #   with Irrlicht Engine reporting No doublebuffering available.
    #
    # Debug File: all test information should wind up in here.
    #
    (testpath/"Library/Application Support/minetest/debug.txt").write("")
    system "#{prefix}/minetest.app/Contents/MacOS/minetest", "--videomodes"
  end
end

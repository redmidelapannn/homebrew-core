class StoneSoup < Formula
  desc "Dungeon Crawl Stone Soup: a roguelike game"
  homepage "https://crawl.develz.org/"
  url "https://crawl.develz.org/release/0.22/stone_soup-0.22.1.tar.xz"
  sha256 "49834a0fbfcba4953359c649fbe52f42b983f5c0cc5e9aa95c5e4066f1453c40"

  bottle do
    rebuild 1
    sha256 "f4085a610b45ace9f1629c8f41d3561aaaf1d715e94f4fb67a0b31e96ab22802" => :mojave
    sha256 "6d235f070015bfec82d5cc197548d7efa1e136a72112a2c02a60459c0db27485" => :high_sierra
    sha256 "06783378a1d47e53368345c88be35db397c2d01d72e2152fd9456f0377e440a9" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lua@5.1"
  depends_on "pcre"

  def install
    ENV.cxx11

    cd "source" do
      args = %W[
        prefix=#{prefix}
        DATADIR=data
        NO_PKGCONFIG=
        BUILD_ZLIB=
        BUILD_SQLITE=yes
        BUILD_FREETYPE=
        BUILD_LIBPNG=
        BUILD_LUA=y
        BUILD_SDL2=
        BUILD_SDL2MIXER=
        BUILD_SDL2IMAGE=
        BUILD_PCRE=
        USE_PCRE=y
      ]

      # FSF GCC doesn't support the -rdynamic flag
      args << "NO_RDYNAMIC=y" unless ENV.compiler == :clang

      # The makefile has trouble locating the developer tools for
      # CLT-only systems, so we set these manually. Reported upstream:
      # https://crawl.develz.org/mantis/view.php?id=7625
      #
      # On 10.9, stone-soup will try to use xcrun and fail due to an empty
      # DEVELOPER_DIR
      devdir = MacOS::Xcode.prefix.to_s
      devdir += "/" if !MacOS::Xcode.installed?

      system "make", "install",
        "DEVELOPER_DIR=#{devdir}", "SDKROOT=#{MacOS.sdk_path}",
        # stone-soup tries to use `uname -m` to determine build -arch,
        # which is frequently wrong on OS X
        "SDK_VER=#{MacOS.version}", "MARCH=#{MacOS.preferred_arch}",
        *args
    end
  end

  test do
    output = shell_output("#{bin}/crawl --version")
    assert_match "Crawl version #{version}", output
  end
end

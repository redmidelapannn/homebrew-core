class Fceux < Formula
  desc "The all in one NES/Famicom Emulator"
  homepage "http://fceux.com"
  url "https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz"
  sha256 "4be6dda9a347f941809a3c4a90d21815b502384adfdd596adaa7b2daf088823e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "7d5f9fb67c9013355a6caf0e0aaee80e0015eb1c09c29a1a9227c4e8c0d2a6cc" => :mojave
    sha256 "7bc7e40ff901731a8ab5cb76255e453cf09baa81d8cc4d429867e42e8729344d" => :high_sierra
    sha256 "b0f83df1bc5062641a23974db644e31db3cf4bebfe21ac047438f77821e95b17" => :sierra
    sha256 "dbe46d9924e6ca4c3eb712df5f6b7349bda80040cb9edc8ccfff4fa85c5f296f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "gtk+3"
  depends_on "sdl"

  # Fix "error: ordered comparison between pointer and zero"
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c126b2c/fceux/xcode9.patch"
      sha256 "3fdea3b81180d1720073c943ce9f3e2630d200252d33c1e2efc1cd8c1e3f8148"
    end
  end

  def install
    # Bypass X11 dependency injection
    # https://sourceforge.net/p/fceultra/bugs/755/
    inreplace "src/drivers/sdl/SConscript", "env.ParseConfig(config_string)", ""

    # gdlib required for logo insertion, but headers are not detected
    # https://sourceforge.net/p/fceultra/bugs/756/
    scons "RELEASE=1", "GTK=0", "GTK3=1", "LOGO=0"
    libexec.install "src/fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    system "#{bin}/fceux", "-h"
  end
end

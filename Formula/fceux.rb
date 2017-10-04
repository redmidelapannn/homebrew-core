class Fceux < Formula
  desc "The all in one NES/Famicom Emulator"
  homepage "http://fceux.com"
  url "https://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.3%20src/fceux-2.2.3.src.tar.gz"
  sha256 "4be6dda9a347f941809a3c4a90d21815b502384adfdd596adaa7b2daf088823e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2fd259db71114585c6b94cced0effe8d7e15879c98f0d1cfa5d403a985694059" => :high_sierra
    sha256 "7369d1f1b73022dadda5d2ace33a3407576dc351b98545c28b6d06cf91518ca5" => :sierra
    sha256 "0bfe0198ddcd2a39a2f6d4c9e93e61a01c5baef8857ad37e4ff49cf6854a8e5b" => :el_capitan
  end

  deprecated_option "no-gtk" => "without-gtk+3"

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "sdl"
  depends_on "gtk+3" => :recommended

  # Fix "error: ordered comparison between pointer and zero"
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c126b2c/fceux/xcode9.patch"
      sha256 "3fdea3b81180d1720073c943ce9f3e2630d200252d33c1e2efc1cd8c1e3f8148"
    end
  end

  def install
    system "2to3", "--write", "--fix=print", "SConstruct", "src/SConscript"

    # Bypass X11 dependency injection
    # https://sourceforge.net/p/fceultra/bugs/755/
    inreplace "src/drivers/sdl/SConscript", "env.ParseConfig(config_string)", ""

    args = []
    args << "RELEASE=1"
    args << "GTK=0"
    args << "GTK3=1" if build.with? "gtk+3"
    # gdlib required for logo insertion, but headers are not detected
    # https://sourceforge.net/p/fceultra/bugs/756/
    args << "LOGO=0"
    scons *args
    libexec.install "src/fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<-EOS.undent
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
      EOS
  end

  test do
    system "#{bin}/fceux", "-h"
  end
end

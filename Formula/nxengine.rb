class Nxengine < Formula
  desc "Rewrite of Cave Story (Doukutsu Monogatari)"
  homepage "https://nxengine.sourceforge.io/"
  url "https://nxengine.sourceforge.io/dl/nx-src-1006.tar.bz2"
  version "1.0.0.6"
  sha256 "cf9cbf15dfdfdc9936720a714876bb1524afbd2931e3eaa4c89984a40b21ad68"

  bottle do
    rebuild 1
    sha256 "bf4aee38248ae5299b65f69cbcac29d17b163c4218c4d4a5834d7f4945fe2a54" => :mojave
    sha256 "c5d17d697fc792f07db5f57d0ef57de4a7046e42c1e78496ed45d4cfed11f540" => :high_sierra
    sha256 "4a2998b14bbe96b2b595e1ee3c442805d34003e3dab81fa345c098bd8ffd442b" => :sierra
    sha256 "e11f371517a9df9502d618cf44c0eb79f2186cce25aee2977a7f8757fe08dcaf" => :el_capitan
  end

  depends_on "sdl"
  depends_on "sdl_ttf"

  # Freeware Cave Story 1.0.0.6 pre-patched with Aeon Genesis English translation
  resource "game" do
    url "https://www.cavestory.org/downloads/cavestoryen.zip"
    sha256 "aa87fa30bee9b4980640c7e104791354e0f1f6411ee0d45a70af70046aa0685f"
  end

  def install
    # Remove unused linux header
    inreplace "platform/Linux/vbesync.c", "#include <libdrm\/drm\.h>", ""
    # Replacement of htole16 for OS X
    inreplace ["sound/org.cpp", "sound/pxt.cpp"] do |s|
      s.gsub! "endian.h", "libkern/OSByteOrder.h"
      s.gsub! "htole16", "OSSwapHostToLittleInt16"
    end
    # Use var/nxengine for extracted data files, without messing current directory
    inreplace "graphics/font.cpp",
              /(fontfile) = "(\w+\.(bmp|ttf))"/,
              "\\1 = \"#{var}/nxengine/\\2\""
    inreplace "platform.cpp",
              /(return .*fopen)\((fname), mode\);/,
              "char fn[256]; strcpy(fn, \"#{var}/nxengine/\"); strcat(fn, \\2); \\1(fn, mode);"
    inreplace "graphics/nxsurface.cpp",
              /(image = SDL_LoadBMP)\((pbm_name)\);/,
              "char fn[256]; strcpy(fn, \"#{var}/nxengine/\"); strcat(fn, \\2); \\1(fn);"
    inreplace "extract/extractpxt.cpp",
              /(mkdir)\((\".+\")/,
              "char dir[256]; strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\2); \\1(dir"
    inreplace "extract/extractfiles.cpp" do |s|
      s.gsub! /char \*dir = strdup\((fname)\);/,
             "char *dir = (char *)malloc(256); strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\1);"
      s.gsub! "strchr", "strrchr"
    end

    system "make"
    bin.install "nx"
    pkgshare.install ["smalfont.bmp", "sprites.sif", "tilekey.dat"]
    resource("game").stage do
      pkgshare.install ["Doukutsu.exe", "data"]
    end
  end

  def post_install
    # Symlink original game data to a working directory in var
    (var/"nxengine").mkpath
    ln_sf Dir[pkgshare/"*"], "#{var}/nxengine/"
    # Use system font, avoiding any license issue
    ln_sf "/Library/Fonts/Courier New.ttf", "#{var}/nxengine/font.ttf"
  end

  def caveats; <<~EOS
    When the game runs first time, it will extract data files into the following directory:
      #{var}/nxengine
  EOS
  end
end

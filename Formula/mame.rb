class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0189.tar.gz"
  version "0.189"
  sha256 "0550d5a1403e4dc4ccab2054468ebe215fd85a43076e02b1aadcacfceb577ddf"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d2b12d578043dd88d83d75cb0db05d3b797adf7030564b43f5c5aace0dc6113a" => :sierra
    sha256 "f290be5330f518c5aac1e76b0bbcc7b87cab04052506f13c6d9ce276e4142815" => :el_capitan
    sha256 "3c04be3f02969d2eb3d95b261b81d61cb9c45eb75c2c25ff95054384e6107525" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "sdl2"
  depends_on "expat"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "sqlite"
  depends_on "portmidi"
  depends_on "portaudio"
  depends_on "utf8proc"

  # Needs compiler and library support C++14.
  needs :cxx14

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2b7053a/mame/jpeg9.patch"
    sha256 "be8095e1b519f17ac4b9e6208f2d434e47346d8b4a8faf001b68749aac3efd20"
  end

  # Patch for Xcode 9: https://github.com/mamedev/mame/issues/2598
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/7ab58e7967/mame/xcode9.patch"
      sha256 "2d7d0ffa9adbee780ce584403f4c2a7386b5edb097321efafc1778fc0200573d"
    end
  end

  def install
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    system "make", "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_LUA=", # Homebrew's lua@5.3 can't build with MAME yet.
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1"
    bin.install "mame64" => "mame"
    cd "docs" do
      system "make", "text"
      doc.install Dir["build/text/*"]
      system "make", "man"
      man1.install "build/man/MAME.1" => "mame.1"
    end
    pkgshare.install %w[artwork bgfx hash ini keymaps plugins samples uismall.bdf]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end

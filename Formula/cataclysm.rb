class Cataclysm < Formula
  desc "Fork/variant of Cataclysm Roguelike"
  homepage "https://github.com/CleverRaven/Cataclysm-DDA"
  url "https://github.com/CleverRaven/Cataclysm-DDA/archive/0.C.tar.gz"
  version "0.C"
  sha256 "69e947824626fffb505ca4ec44187ec94bba32c1e5957ba5c771b3445f958af6"

  head "https://github.com/CleverRaven/Cataclysm-DDA.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c136609177f7f48d4bc12fdb7d1764a78bbd887a30d0acfa474ddfe0c50c1c7a" => :sierra
    sha256 "3bcf3ec604fbba2fc9bf74abbf501eb8eb212007f34e512bbde289e4cd911123" => :el_capitan
    sha256 "00fd79e911e1cb960bbcde447ec3266faba4686678f9d7c29cde7b9de4e5e0cb" => :yosemite
  end

  option "with-tiles", "Enable tileset support"

  needs :cxx11

  depends_on "gettext"
  # needs `set_escdelay`, which isn't present in system ncurses before 10.6
  depends_on "ncurses" if MacOS.version < :snow_leopard

  if build.with? "tiles"
    depends_on "sdl2"
    depends_on "sdl2_image"
    depends_on "sdl2_ttf"
  end

  def install
    ENV.cxx11

    # cataclysm tries to #import <curses.h>, but Homebrew ncurses installs no
    # top-level headers
    ENV.append_to_cflags "-I#{Formula["ncurses"].include}/ncursesw" if MacOS.version < :snow_leopard

    args = %W[
      NATIVE=osx RELEASE=1 OSX_MIN=#{MacOS.version}
    ]

    args << "TILES=1" if build.with? "tiles"
    args << "CLANG=1" if ENV.compiler == :clang

    system "make", *args

    # no make install, so we have to do it ourselves
    if build.with? "tiles"
      libexec.install "cataclysm-tiles", "data", "gfx"
    else
      libexec.install "cataclysm", "data"
    end

    inreplace "cataclysm-launcher" do |s|
      s.change_make_var! "DIR", libexec
    end
    bin.install "cataclysm-launcher" => "cataclysm"
  end
end

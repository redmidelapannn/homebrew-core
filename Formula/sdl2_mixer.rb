class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.2.tar.gz"
  sha256 "4e615e27efca4f439df9af6aa2c6de84150d17cbfd12174b54868c12f19c83bb"
  revision 3
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "7d08b72b2639dc0d080413bb1d025f56db50d0cbff2fa74685874dec7b605492" => :high_sierra
    sha256 "480adc75c2eca5aefd5ab0c416976eeb205f5a0052f0dd0dea4871bc099f3d2b" => :sierra
    sha256 "c3c6ba3e1ceecf1dc020bea3e1101e00f8ed04dbdb004f7310b7eaae9e4759dc" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "libmikmod" => :optional
  depends_on "mpg123" => :optional

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix} --disable-dependency-tracking
      --enable-music-ogg --disable-music-ogg-shared
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --enable-music-mod-modplug
      --disable-music-mod-modplug-shared
      --disable-music-mp3-smpeg
      --disable-music-mp3-mpg123-shared
    ]

    args << "--disable-music-flac" if build.without? "flac"
    args << "--disable-music-midi-fluidsynth" if build.without? "fluid-synth"
    args << "--enable-music-mod-mikmod" if build.with? "libmikmod"
    args << "--disable-music-mp3-mpg123" if build.without? "mpg123"

    system "./configure", *args
    system "make", "install"
  end
end

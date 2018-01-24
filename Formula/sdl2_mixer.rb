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
    sha256 "c407184f801881feb91c219179e2843838c556f267aabc716b2f66ee5b96f552" => :high_sierra
    sha256 "4e15c23704d4b0d21913d9bff00217e03e0943db548120861e28daa18187f15c" => :sierra
    sha256 "348eea579313a7118f1f9896ec089dfb1d723707ba3d1753645ca83d743f13ac" => :el_capitan
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

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          int success = Mix_Init(0);
          Mix_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_mixer", "test.c", "-o", "test"
    system "./test"
  end
end

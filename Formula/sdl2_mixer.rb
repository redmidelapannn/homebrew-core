class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz"
  sha256 "b4cf5a382c061cd75081cf246c2aa2f9df8db04bdda8dcdc6b6cca55bede2419"
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "2bc1c07f7606bf817968128aa25c4a59a318046afa083883ba5fbc3d69755886" => :mojave
    sha256 "291f9f96c0067096cda84f0a47e28f7083c0d62f5f8158aa57a3dca17f1df46f" => :high_sierra
    sha256 "30ac9438e792f4dbb633bd52aa9725aa28c8290577996651071ffb7350dc1a27" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libvorbis"
  depends_on "sdl2"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-music-flac
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --disable-music-mod-modplug-shared
      --disable-music-mp3-mpg123
      --disable-music-mp3-mpg123-shared
      --disable-music-mp3-smpeg
      --disable-music-ogg-shared
      --enable-music-mod-mikmod
      --enable-music-mod-modplug
      --enable-music-ogg
    ]

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

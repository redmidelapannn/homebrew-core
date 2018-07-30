class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  revision 3

  bottle do
    rebuild 1
    sha256 "1b05d050e5b58a5a7cd4ae8e16f5c90365ac2e5524cbab139d4d777e9a1ea3e2" => :high_sierra
    sha256 "0318de733fb40d2b63d20c4fea138f8157d848d445e9de70936825b2b9fdf968" => :sierra
    sha256 "7a79af3ab2d0c2cd1d67e0062daccf0dac09222e39dfe032897195e41a64a2cf" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libmikmod"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg" => :optional

  # Fix for "crash on double free if loading WAV file failed"
  # https://bugzilla.libsdl.org/show_bug.cgi?id=1418
  patch do
    url "https://git.archlinux.org/svntogit/packages.git/plain/trunk/double-free-crash.patch?h=packages/sdl_mixer"
    sha256 "b707f5c8d1229d1612cc8a9f4e976f0a3b19ea40d7bd1d5bc1cbd5c9f8bca56d"
  end

  # playwav.c, a sdl_mixer example.
  resource "test_artifact" do
    url "https://hg.libsdl.org/SDL_mixer/raw-file/a4e9c53d9c30/playwave.c"
    version "1"
    sha256 "92f686d313f603f3b58431ec1a3a6bf29a36e5f792fb78417ac3d5d5a72b76c9"
  end

  def install
    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-ogg
      --disable-music-ogg-shared
      --disable-music-mod-shared
    ]

    args << "--disable-music-fluidsynth-shared" if build.with? "fluid-synth"
    args << "--disable-music-flac-shared" if build.with? "flac"
    args << "--disable-music-mp3-shared" if build.with? "smpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    testpath.install resource("test_artifact")
    system ENV.cc, "-o", "playwave", "playwave.c", "-I/usr/local/include/SDL",
                   "-D_GNU_SOURCE=1", "-D_THREAD_SAFE", "-L/usr/local/lib",
                   "-lSDLmain", "-lSDL", "-Wl,-framework,Cocoa", "-lSDL_mixer"
    output = "SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=disk ./playwave /usr/local/Homebrew/Library/Homebrew/test/support/fixtures/test.wav"
    system output
  end
end

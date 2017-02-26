class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.1.tar.gz"
  sha256 "5a24f62a610249d744cbd8d28ee399d8905db7222bf3bdbc8a8b4a76e597695f"
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "4d7d87bf4acc18f3c9f49c8a2eb29b85bdb789d39bc31d681bb3003c9911bc6a" => :sierra
    sha256 "61377e7cd2527feb077d8a851ac8898d464a29826d9c81e10595d2f6529cb139" => :el_capitan
    sha256 "42f91c29e2c325c3407a0b87209ca833bf28df62afe973c2ff463ae04c570650" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg2" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libmodplug" => :optional
  depends_on "libvorbis" => :optional

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    ENV["SMPEG_CONFIG"] = "#{Formula["smpeg2"].bin}/smpeg2-config" if build.with? "smpeg2"

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--enable-music-mod-mikmod" if build.with? "libmikmod"
    args << "--enable-music-mod-modplug" if build.with? "libmodplug"

    system "./configure", *args
    system "make", "install"
  end
end

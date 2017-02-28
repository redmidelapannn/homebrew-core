class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.1.tar.gz"
  sha256 "5a24f62a610249d744cbd8d28ee399d8905db7222bf3bdbc8a8b4a76e597695f"
  head "https://hg.libsdl.org/SDL_mixer", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "8c79f06a38f78a4e3a9a802acd341cfec957ae18ba585caa70dea8fcb65c33a6" => :sierra
    sha256 "c475af2c8574a5049294be1071f7513005ab84eef9c83df2a9f0fed95b4b9c9e" => :el_capitan
    sha256 "4f9ae673b1e9e78dfcd593daef5f0ef61e13b63480f86bd1902833afebadb434" => :yosemite
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

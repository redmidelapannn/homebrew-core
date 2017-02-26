class SdlMixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://www.libsdl.org/projects/SDL_mixer/"
  url "https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-1.2.12.tar.gz"
  sha256 "1644308279a975799049e4826af2cfc787cad2abb11aa14562e402521f86992a"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "f29dd0201daddfea52a599d7017e01d09f00425d6a22eb5621c6d092babfdfe2" => :sierra
    sha256 "3bd81f94d341ca2d3ebf04741726efbf6d92c11d8b91e1f47ec5735d036f2180" => :el_capitan
    sha256 "11b261eccb2f55a91d507d400dc94ba63736f0247c89322ebfe5676b9173dc50" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "smpeg" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libvorbis" => :optional

  def install
    inreplace "SDL_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << "--disable-music-mod-shared" if build.with? "libmikmod"
    args << "--disable-music-fluidsynth-shared" if build.with? "fluid-synth"
    args << "--disable-music-ogg-shared" if build.with? "libvorbis"
    args << "--disable-music-flac-shared" if build.with? "flac"
    args << "--disable-music-mp3-shared" if build.with? "smpeg"

    system "./configure", *args
    system "make", "install"
  end
end

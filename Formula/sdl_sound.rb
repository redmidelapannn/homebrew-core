class SdlSound < Formula
  desc "Library to decode several popular sound file formats"
  homepage "https://icculus.org/SDL_sound/"
  url "https://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sdl-sound1.2/sdl-sound1.2_1.0.3.orig.tar.gz"
  sha256 "3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9527976a6b5312e634108fb9c98b9c5679fc65b4365c8f8fec3af2e1c559a46b" => :sierra
    sha256 "1aa398bbe2baa89442a6efd85b9d190737f9249332f6a0e12ff102daf2d0931a" => :el_capitan
    sha256 "d58f5cbe6d1e5657739f3776269bacf022ec4f8db9687e7951e9c15b67bd5ccb" => :yosemite
  end

  head do
    url "https://hg.icculus.org/icculus/SDL_sound", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "flac" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libogg" => :optional
  depends_on "libvorbis" => :optional
  depends_on "speex" => :optional
  depends_on "physfs" => :optional

  def install
    if build.head?
      inreplace "bootstrap", "/usr/bin/glibtoolize", "#{Formula["libtool"].opt_bin}/glibtoolize"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end

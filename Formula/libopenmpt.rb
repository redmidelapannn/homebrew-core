class Libopenmpt < Formula
  desc "OpenMPT based module player library and libopenmpt based cli player"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.2.6611-beta18-autotools.tar.gz"
  sha256 "cdb870512d887d01dfdeebb20433669d49d27aa719e1997c4490a624e65fd9ea"

  bottle do
    cellar :any
    sha256 "340d0f827414d96c027c113a6931762e9bad6c122346f23c60b6b005fe923894" => :el_capitan
    sha256 "171e04b5c57d651431209a0feb75f832c7636ab0b28dcf99d5cf6eee0f2302cb" => :yosemite
    sha256 "c190a7ab6c73a32272f2a4fa957e7991ca6eecc4b5fa78fe32bda9b751429525" => :mavericks
  end

  depends_on "lzlib"=> :build
  depends_on "pkg-config"=> :build
  depends_on "doxygen"=> :build
  depends_on "mpg123"=> :build
  depends_on "libtool"=> :build

  depends_on "portaudio"=> :recommended
  depends_on "libsndfile"=> :recommended

  depends_on "libogg"=> :optional
  depends_on "libvorbis"=> :optional
  depends_on "pulseaudio"=> :optional
  depends_on "flac"=> :optional

  def install
    args = ["--disable-silent-rules"]

    # recommended
    args << "--without-portaudio"  if build.without? "portaudio"
    args << "--without-libsndfile" if build.without? "libsndfile"
    # optional
    args << "--without-libogg"     if build.without? "libogg"
    args << "--without-libvorbis"  if build.without? "libvorbis"
    args << "--without-pulseaudio" if build.without? "pulseaudio"
    args << "--without-flac"       if build.without? "flac"
    args << "--with-sdl"           if build.with?    "sdl"
    args << "--with-sdl2"          if build.with?    "sdl2"

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
  end

  test do
    system "#{bin}/openmpt123", "-h"
  end
end

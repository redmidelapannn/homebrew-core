class ViceSdl2 < Formula
  desc "Versatile Commodore Emulator - SDL2"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.3.tar.gz"
  sha256 "1a55b38cc988165b077808c07c52a779d181270b28c14b5c9abf4e569137431d"
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  bottle do
    sha256 "bed149005bfa75cd74223bcb5c157c318a3a5ef3ca5996800bb4d70e0ca7bf89" => :mojave
    sha256 "c2c0eefa1f5de0b86ed08a6389cc6d5eaab3371dff4c0521e772c398d412ee41" => :high_sierra
    sha256 "dddf4463459dc57335906b801b9ccd1d3809b57cdcf5604986bce68b60dcf636" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build
  depends_on "autoconf" if build.head?
  depends_on "automake" if build.head?
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "sdl2"
  depends_on "xz"

  def install
    configure_flags = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--disable-arch",
      "--disable-bundle",
      "--enable-external-ffmpeg",
      "--enable-sdlui2",
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *configure_flags
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end

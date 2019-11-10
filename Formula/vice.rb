class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.3.tar.gz"
  sha256 "1a55b38cc988165b077808c07c52a779d181270b28c14b5c9abf4e569137431d"
  revision 2
  head "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  bottle do
    rebuild 1
    sha256 "cc7ff1f1f87c8dce949ea40d69442d847f3010534e4dd04b1d49947a9ab8403f" => :catalina
    sha256 "b7caa91236c5638deac73a2e84a3aa7da62541e6e576b0ce61c3be0bed25b341" => :mojave
    sha256 "93841c05027ce81896d7874765556b450cf5292ff72c9713a9adaea860aeb546" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "xa" => :build
  depends_on "yasm" => :build
  depends_on "autoconf" if build.head?
  depends_on "automake" if build.head?
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "giflib"
  depends_on "gtk+3" if build.head?
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libnet"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "sdl2" unless build.head?
  depends_on "xz"

  def install
    configure_flags = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--disable-arch",
      "--enable-external-ffmpeg",
    ]

    if build.head?
      configure_flags << "--enable-native-gtk3ui"
    else
      configure_flags << "--disable-bundle"
      configure_flags << "--enable-sdlui2"
    end

    system "./autogen.sh" if build.head?
    system "./configure", *configure_flags
    system "make", "install"
  end

  def caveats; <<~EOS
    App bundles are no longer built for each emulator. The binaries are
    available in #{HOMEBREW_PREFIX}/bin directly instead.
  EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/petcat -help", 1)
  end
end

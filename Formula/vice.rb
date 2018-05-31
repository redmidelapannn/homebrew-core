class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage "https://vice-emu.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vice-emu/releases/vice-3.2.tar.gz"
  sha256 "28d99f5e110720c97ef16d8dd4219cf9a67661d58819835d19378143697ba523"

  bottle do
    sha256 "f1f9ac0f211da653e048c77fcd69b33d6a69fead2d3c3bc83b52f19c678812c5" => :high_sierra
    sha256 "841b568fbf3d2b772dd3d77bee2de951f5a96a66a08b856b4893fa135261a6c6" => :sierra
    sha256 "08e4bbb2db92d460af363127dd6cd5d6ca625f9e15a10fb7dd9c623b895bfb10" => :el_capitan
  end

  head do
    url "https://svn.code.sf.net/p/vice-emu/code/trunk/vice"

  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on "yasm" => :build
  depends_on "xa" => :build
  depends_on "ffmpeg@2.8"
  depends_on "flac"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"
  depends_on "xz"
  depends_on "sdl2"
  depends_on "gtk+3" => :optional

  def install
    ENV.prepend_path "PATH", "/usr/local/opt/ffmpeg@2.8/bin"
    ENV.prepend_path "PKG_CONFIG_PATH", "/usr/local/opt/ffmpeg@2.8/lib/pkgconfig"

    if build.with?("gtk+3") && !build.head?
      odie "Can only build gtk3ui with '--HEAD'."
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-bundle
      --enable-external-ffmpeg
      --disable-arch
    ]

    args << "--enable-debug" if build.with? "debug"
    args << "--enable-sdlui2" if build.without? "gtk+3"
    args << "--enable-native-gtk3ui" if build.with? "gtk+3"

    # Hardcode this so people do not have to set DYLD_LIBRARY_PATH
    inreplace "src/arch/sdl/archdep_unix.h", "\"lib\" #name \".\" #version \".dylib\"", "\"/usr/local/opt/ffmpeg@2.8/lib/lib\" #name \".\" #version \".dylib\"" if build.without? "gtk+3"
    inreplace "src/arch/gtk3/archdep_unix.h", "\"lib\" #name \".\" #version \".dylib\"", "\"/usr/local/opt/ffmpeg@2.8/lib/lib\" #name \".\" #version \".dylib\"" if build.with? "gtk+3"

    # Skip the X11 font stuff
    inreplace "data/fonts/Makefile.am", %r{^@SDL_COMPILE_FALSE@}, "@SDL_COMPILE_FALSE@@UNIX_MACOSX_COMPILE_FALSE@" if build.with? "gtk+3"

    system "./autogen.sh" if build.head?
    system "./configure", *args
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

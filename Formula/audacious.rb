class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "http://audacious-media-player.org"

  stable do
    url "http://distfiles.audacious-media-player.org/audacious-3.8.2.tar.bz2"
    sha256 "bdf1471cce9becf9599c742c03bdf67a2b26d9101f7d865f900a74d57addbe93"

    resource "plugins" do
      url "http://distfiles.audacious-media-player.org/audacious-plugins-3.8.2.tar.bz2"
      sha256 "d7cefca7a0e32bf4e58bb6e84df157268b5e9a6771a0e8c2da98b03f92a5fdd4"
    end
  end

  bottle do
    rebuild 1
    sha256 "e9a98fe6be82ca54e7825ac77cad41fbf1b0e31d405f183d135718fc7928bf47" => :sierra
    sha256 "4fbfc0866cc93de2e95e8d74f942bd7d7b977b70f7a8cb8c9f9f9fb929496bc9" => :el_capitan
    sha256 "348cbaadb2a6877012aaa2d0938c93d140f5e130e6d8f5bea43af3b41aa7e414" => :yosemite
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git"
    end

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libnotify"
  depends_on "libsamplerate"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "sdl2"
  depends_on "wavpack"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "qt" => :recommended
  depends_on "gtk+" => :optional
  depends_on "jack" => :optional
  depends_on "libmms" => :optional
  depends_on "libmodplug" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-coreaudio
      --enable-mac-media-keys
      --disable-mpris2
    ]

    args << "--enable-qt" if build.with? "qt"
    args << "--disable-gtk" if build.without? "gtk+"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("plugins").stage do
      ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./autogen.sh" if build.head?

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
    audtool does not work due to a broken dbus implementation on macOS, so is not built
    coreaudio output has been disabled as it does not work (Fails to set audio unit input property.)
    GTK+ gui is not built by default as the QT gui has better integration with macOS, and when built, the gtk gui takes precedence
    EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end

class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  revision 2

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-3.9.tar.bz2"
    sha256 "2d8044673ac786d71b08004f190bbca368258bf60e6602ffc0d9622835ccb05e"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-3.9.tar.bz2"
      sha256 "8bf7f21089cb3406968cc9c71307774aee7100ec4607f28f63cf5690d5c927b8"

      # Fixes "info_bar.cc:258:21: error: no viable overloaded '='"
      # Upstream PR from 11 Dec 2017 "qtui: fix build with Qt 5.10"
      patch do
        url "https://github.com/audacious-media-player/audacious-plugins/pull/62.patch?full_index=1"
        sha256 "055e11096de7a8b695959b0d5f69a7f84630764f7abd7ec7b4dc3f14a719d9de"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "ab40418a2f83b1bac94304d1ecb28226cfc786dc680fd19099840f66ce5e0f60" => :mojave
    sha256 "58d9eb72f5d8d0c37219ddc8c4b70919a6a398dba2b2abf8cd33e04769af2bff" => :high_sierra
    sha256 "a595687aa569e7308da89bae1d23276766119400f6fb9a757b422e921a8600a7" => :sierra
    sha256 "ea6e2046e8b9f48848aca4cf9938f46404b66a8be2e61fc55731f71a266005ab" => :el_capitan
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
  depends_on "python@2"
  depends_on "qt"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-coreaudio
      --disable-gtk
      --disable-mpris2
      --enable-mac-media-keys
      --enable-qt
    ]

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

  def caveats; <<~EOS
    audtool does not work due to a broken dbus implementation on macOS, so is not built
    coreaudio output has been disabled as it does not work (Fails to set audio unit input property.)
    GTK+ gui is not built by default as the QT gui has better integration with macOS, and when built, the gtk gui takes precedence
  EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end

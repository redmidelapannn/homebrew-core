class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.12.3.tar.xz"
  sha256 "d388f492440897f02b01eebb033ca2d41078a3d85c0eddc030cdea5a337a216e"

  bottle do
    rebuild 1
    sha256 "53ce1371d69cf01e62cfa6d632dbe2fd25beee5e75d41d4953561487e8275627" => :high_sierra
    sha256 "5d1ce725e9e88314b5dcd508a5ae52c3ea870a69348a2b24f88b57cd3ed90199" => :sierra
    sha256 "f87af9f8c395b0efec51a5b9569529042bc3ba261d5f74d4624eeef9c7e457d3" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gstreamer.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "gettext"
  depends_on "glib"
  depends_on "bison"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-gtk-doc
      --enable-introspection=yes
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"

      # Ban trying to chown to root.
      # https://bugzilla.gnome.org/show_bug.cgi?id=750367
      args << "--with-ptp-helper-permissions=none"
    end

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "configure", 'PLUGINDIR="$full_var"',
      "PLUGINDIR=\"#{HOMEBREW_PREFIX}/lib/gstreamer-1.0\""

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Consider also installing gst-plugins-base and gst-plugins-good.

    The gst-plugins-* packages contain gstreamer-video-1.0, gstreamer-audio-1.0,
    and other components needed by most gstreamer applications.
    EOS
  end

  test do
    system bin/"gst-inspect-1.0"
  end
end

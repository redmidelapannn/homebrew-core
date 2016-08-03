class Gstreamer < Formula
  desc "development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.8.2.tar.xz"
  sha256 "9dbebe079c2ab2004ef7f2649fa317cabea1feb4fb5605c24d40744b90918341"

  bottle do
    revision 1
    sha256 "aba6039ab7f0a02c0fd819132b0621f9da20a1cb8f8dec0ac1d424906613181c" => :el_capitan
    sha256 "ab48a0b47927689c35b05a58908254b843c4feab1e018a8877d9ded2c261c9bc" => :yosemite
    sha256 "734102e10894f08e87471485136d947411529005b6eb8736fe33d633e038deea" => :mavericks
  end

  devel do
    url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.9.1.tar.xz"
    sha256 "55304a9e1e8fb5ef82b5b246fef2d9a164eeb0466976a3ad19cfae05b8a94159"
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

  test do
    system bin/"gst-inspect-1.0"
  end
end

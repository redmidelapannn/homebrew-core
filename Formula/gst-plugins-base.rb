class GstPluginsBase < Formula
  desc "GStreamer plugins (well-supported, basic set)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.12.3.tar.xz"
  sha256 "d3d37b8489d37fa0018973d850bd2067b98af335fef2fa543ee7d40359e3cea5"

  bottle do
    sha256 "fb350c4d740abe43ca0b56496f253f20a73cfb1ad2e128e18d6d80b36bb39746" => :high_sierra
    sha256 "dc0902553834f62b3f23105b128a99697393be0e31acc712d68ecb7194f86aed" => :sierra
    sha256 "b3c3d586d61763a040d146ebdd39b74178a612bc5b4a4f842f0ab5ec3b6c272f" => :el_capitan
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-base.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"

  # The set of optional dependencies is based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-base/tree/REQUIREMENTS
  # and Homebrew formulae
  depends_on "gobject-introspection"
  depends_on "orc" => :recommended
  depends_on "libogg" => :optional
  depends_on "opus" => :optional
  depends_on "pango" => :optional
  depends_on "theora" => :optional
  depends_on "libvorbis" => :optional

  def install
    # gnome-vfs turned off due to lack of formula for it.
    args = %W[
      --prefix=#{prefix}
      --enable-experimental
      --disable-libvisual
      --disable-alsa
      --disable-cdparanoia
      --without-x
      --disable-x
      --disable-xvideo
      --disable-xshm
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=yes
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin volume")
    assert_match version.to_s, output
  end
end

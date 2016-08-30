class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  revision 1

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.8.3.tar.xz"
    sha256 "7899fcb18e6a1af2888b19c90213af018a57d741c6e72ec56b133bc73ec8509b"
  end

  bottle do
    rebuild 1
    sha256 "2bd2f2f973bff27033cd8c717ac0a4a87f5f697ca227d34d1072efbbefeb2018" => :el_capitan
    sha256 "c42c1cecda8575a3630a53d2dcbf66fe8ccb93d7f671086b568af641d42582d2" => :yosemite
    sha256 "7a1dd9e6df67ed9932f6931381537ee04e87598fddfb9841b90bd3c5725e1d00" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "openssl"

  depends_on "orc" => :recommended
  depends_on "dirac" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :optional
  depends_on "gnutls" => :optional
  depends_on "gtk+3" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libexif" => :optional
  depends_on "libmms" => :optional
  depends_on "homebrew/science/opencv" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sound-touch" => :optional
  depends_on "srtp" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-sdl
      --disable-debug
      --disable-dependency-tracking
    ]

    # upstream does not support Apple video for older SDKs
    # error: use of undeclared identifier 'AVQueuedSampleBufferRenderingStatusFailed'
    # https://github.com/Homebrew/legacy-homebrew/pull/35284
    # applemedia plugin fails to build on Sierra
    # https://bugzilla.gnome.org/show_bug.cgi?id=770587
    if MacOS.version <= :mavericks or MacOS.version == :sierra
      args << "--disable-apple_media"
    end

    args << "--with-gtk=3.0" if build.with? "gtk+3"

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
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end

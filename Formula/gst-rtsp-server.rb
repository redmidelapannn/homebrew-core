class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.12.3.tar.xz"
  sha256 "67255971bb16029a01de66b9f9687f20d8dbf3d3bd75feb48605d0723a7c74ec"

  bottle do
    sha256 "2228a3fc3a45c11f02780c0841fae9bdc97784d2988015daccf6510dd35648e8" => :high_sierra
    sha256 "18398413a27172e8241047a50a365a2ab2d6059632db362822d31af4be84e75e" => :sierra
    sha256 "e3d282bb85f48ed2e0053515893dfa823c7c5a289056d83995171ec0fabbcba4" => :el_capitan
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-examples",
                          "--disable-tests",
                          "--enable-introspection=yes"

    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --gst-plugin-path #{lib} --plugin rtspclientsink")
    assert_match /\s#{version.to_s}\s/, output
  end
end

class GstRtspServer < Formula
  desc "RTSP server library based on GStreamer"
  homepage "https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
  url "https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.12.0.tar.xz"
  sha256 "85ae6bbe173b365ddf4859967144f1999b436531ecbe09935914bfa9f6b37652"

  bottle do
    sha256 "4bc71cc95a86f2bd175117dbb4956b68098dee85c0b2b7ee64c2b86a57a70421" => :sierra
    sha256 "0a9072fee79754d88f8000fadd6e010b2a763e89dd92bed1c40abbb4640c27e3" => :el_capitan
    sha256 "20146b0b4260d476d79a5e5401a19c93045bed65bcf3798101ac226365e369a0" => :yosemite
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

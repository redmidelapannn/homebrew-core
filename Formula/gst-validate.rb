class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.12.0.tar.xz"
  sha256 "73efaf123638b97159c1ff6575dd05ea0cf7dc6d71b07806b5a5f25188a67fbb"

  bottle do
    sha256 "c89e53fc597182c937d2f9c97e462607b69123b29ad6a88a39e868f4412ddc91" => :sierra
    sha256 "55d7c148af0bbb794d89c5b957c3167b71c14a892e0ea6b0af6e6c6120ebf42e" => :el_capitan
    sha256 "38d0c0228073fae2debda296792fef69a55abbc3cbafba8ad04cbd3869017236" => :yosemite
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"
  depends_on "json-glib"

  def install
    inreplace "tools/gst-validate-launcher.in", "env python3", "env python"

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      cd "validate" do
        system "./autogen.sh"
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    else
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end

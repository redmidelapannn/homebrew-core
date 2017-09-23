class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.12.3.tar.xz"
  sha256 "5139949d20274fdd702492438eeab2c9e55aa82f60aca17db27ebd3faf08489e"

  bottle do
    sha256 "604d9d1bd753c340124d0b73a65489d81f9feeebf0b5e0658c3d234514df3c87" => :high_sierra
    sha256 "0479d934fcc48bba0196bc0895af6a7cf769e520f10b0e896bf20012eb1f943b" => :sierra
    sha256 "71881531bd5a75dc10adca076bf745efb0c81d0c7cab226d4fdfa89cb07446f6" => :el_capitan
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

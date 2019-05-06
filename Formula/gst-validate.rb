class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.16.0.tar.xz"
    sha256 "9331ae48a173a048243539730cc7a88607777762dea4aebbc3ab55981e68d6c9"

    patch :p2 do
      url "https://gitlab.freedesktop.org/gstreamer/gst-devtools/commit/751a6d756c0f7c3a721a235ced74fec17f038185.patch"
      sha256 "c34335e6647fa8ecf7e9406666cf817a4810619208282d27be7f213d95dd98f1"
    end
  end

  bottle do
    sha256 "c5e1c414ecc0232431b21cb0696e5a47f74d7d34fc652c2f6170f431c39a7fe8" => :mojave
    sha256 "615a37ce9755d3a60b1a59e3c384af8822a29cac4cfb26be35eb308c9199e5d0" => :high_sierra
    sha256 "f187c1ed1e8e49fcb0f423fe2841b110a7e42d2a296c83abb81546c7deab1e3a" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
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

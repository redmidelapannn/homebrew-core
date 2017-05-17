class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.12.0.tar.xz"
  sha256 "39d1477f642ee980b008e78d716b16801eec9a6e5958c5a6cdc0cb04ab0750c4"

  bottle do
    sha256 "d38c3bc3b3f9044bca516bc97ff2b81d25729c8a732c68f8f68b1cdd8b005aee" => :sierra
    sha256 "5a1ae9eae33da0571a40a37dfc4086c729ab2455acc53dc33d55899675cc440e" => :el_capitan
    sha256 "dade8e8a738545f19a91ec0dc569e8571ac2f336cb2adcae5bba6de1ee2fd573" => :yosemite
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-libav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext"
  end

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end

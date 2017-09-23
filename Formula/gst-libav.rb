class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.12.3.tar.xz"
  sha256 "015ef8cab6f7fb87c8fb42642486423eff3b6e6a6bccdcd6a189f436a3619650"

  bottle do
    sha256 "eb8f9a39f0e5a86a9e55c5d12353add8df0ea7f0574f09bb6383c4dd1525d590" => :high_sierra
    sha256 "6fb2f35c6fedd2c612b93ca6216e280e87ef9ce2a7b7e5f655b888661c52476a" => :sierra
    sha256 "c64f40c475d436b62847a8329ee11bad247e1462fa62b1aa9593bb82f607a1a0" => :el_capitan
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

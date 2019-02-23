class Aravis < Formula
  desc "Vision library for genicam based cameras"
  homepage "https://wiki.gnome.org/Projects/Aravis"
  url "https://github.com/AravisProject/aravis/archive/ARAVIS_0_6_1.tar.gz"
  sha256 "d9795d36bfb1af230bda21d93bc81390f49d936c6c9b7b3043a5c09bd0f0f8d3"

  bottle do
    sha256 "b4afdb103d1880599437e161d285f3fa1c578fa1125d50d22e1d408d944402bc" => :mojave
    sha256 "4208c03965f10ea0aac58ef1684df8fbc3d576fc28dff2d4b256f6965caf36d5" => :high_sierra
    sha256 "2e58d72e88f5fd6dd6688135355307a78f79160291289bb3a5940a8fb74c5f33" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "libusb"

  def install
    inreplace "viewer/Makefile.am", "gtk-update-icon-cache", "gtk3-update-icon-cache"
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("gst-inspect-1.0 #{lib}/gstreamer-1.0/libgstaravis.0.6.so")
    assert_match /Description *Aravis Video Source/, output
  end
end

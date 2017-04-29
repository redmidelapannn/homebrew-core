class Corebird < Formula
  desc "Native Gtk+ Twitter Client"
  homepage "https://corebird.baedert.org"
  url "https://github.com/baedert/corebird/releases/download/1.4.2/corebird-1.4.2.tar.xz"
  sha256 "1c07a65382e78308f7de406be8464789c1ec42d531c519b69510a685234b4074"

  bottle do
    sha256 "b22e1b856d4a0b644206b49abf2ab291f8af0a59ed6d47d05f86ea4506e5e835" => :sierra
    sha256 "5ed4d39fc095b6d05c087438c12271ffff29c91f959d05f7cf95cca39fe3ead8" => :el_capitan
    sha256 "9eb4cfb6a14d04a81422b849167e49eb68aeb1bb8d6ec19472e6ae70ee9aaefe" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "librest"
  depends_on "libsoup"
  depends_on "json-glib"
  depends_on "gspell"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-libav"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-schemas-compile",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "false"
  end
end

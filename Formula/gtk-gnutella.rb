class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.15/gtk-gnutella-1.1.15.tar.xz"
  sha256 "2931fab394b6d36c14a6bbc3b0ff584af5550f2eeb03f78bb19743c47767c1b7"

  bottle do
    sha256 "0ec7ab3fd03eb1aeae72a661dfb370d3c1e9bebcfca06dcf8e43810285cd502c" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  def install
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "Configure", "ret = clock_gettime(CLOCK_REALTIME, &tp);",
                             "ret = undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end

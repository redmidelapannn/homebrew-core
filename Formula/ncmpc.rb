class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.26.tar.xz"
  sha256 "8bd2365cac73692ca03166e60bec2113ee00f42a4137e4ab47742452733b0d14"

  bottle do
    rebuild 1
    sha256 "3100c3dc468adaeaa77c60256c58a187206fd8ee644d6b2579fc4f8d480ff127" => :sierra
    sha256 "b5c364527e5714405e0a428b18965b1681321a574ac19be3819c831ec8b518cd" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end
end

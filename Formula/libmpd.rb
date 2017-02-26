class Libmpd < Formula
  desc "Higher level access to MPD functions"
  homepage "https://gmpc.wikia.com/wiki/Gnome_Music_Player_Client"
  url "https://www.musicpd.org/download/libmpd/11.8.17/libmpd-11.8.17.tar.gz"
  sha256 "fe20326b0d10641f71c4673fae637bf9222a96e1712f71f170fca2fc34bf7a83"

  bottle do
    cellar :any
    rebuild 2
    sha256 "8e6b683abdf02e0e2456c96ccb5771b9a1cfc8855b4fc7e225798ae457fe29ff" => :sierra
    sha256 "4910b124a99146239f6effee7065ba7badcde4a3fb20e24bdb9d8a55fd7149fa" => :el_capitan
    sha256 "fcce5398a4785f4149cb274d14c958ffee1eac25b1efceb610f52d18450e45fc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

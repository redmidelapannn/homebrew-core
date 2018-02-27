class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://web.archive.org/web/20161127214942/jnettop.kubs.info/wiki/"
  # Please switch back to the canonical source on the next update:
  # https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/j/jnettop/jnettop_0.13.0.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/j/jnettop/jnettop_0.13.0.orig.tar.gz"
  sha256 "e987a1a9325595c8a0543ab61cf3b6d781b4faf72dd0e0e0c70b2cc2ceb5a5a0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "880eda19e97187ca772b789fa188dbc5aa90f94592235fdad135907c74c319e0" => :high_sierra
    sha256 "c660dc91a5453729cc2c02312babdfd26db87572704eff23feb5d32f9fc70853" => :sierra
    sha256 "f7989233109e5a152df6b0949eba32f8325425f1ec3708a803f41f95101e09ac" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/jnettop", "-h"
  end
end

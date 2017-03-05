class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  # http://jnettop.kubs.info/ is offline
  homepage "https://packages.debian.org/sid/net/jnettop"
  # http://jnettop.kubs.info/dist/jnettop-0.13.0.tar.gz is offline
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/j/jnettop/jnettop_0.13.0.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/j/jnettop/jnettop_0.13.0.orig.tar.gz"
  sha256 "e987a1a9325595c8a0543ab61cf3b6d781b4faf72dd0e0e0c70b2cc2ceb5a5a0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "997f7a3c360f8eddcb00bad7492ab8db1a5d57556cf42c4dcf2082c039363088" => :sierra
    sha256 "b43050e716338fe56a0a1a1a4341374ea5b7c0e8b73de4638488a6631f1176af" => :el_capitan
    sha256 "e30f2d31eeb9a4df9bb213083a49529c9a33a3531c1282c1a8c179fef2ba2b09" => :yosemite
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

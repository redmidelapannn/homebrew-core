require "etc"

class Slashem < Formula
  desc "Fork/variant of Nethack"
  homepage "https://slashem.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/slashem/slashem-source/0.0.8E0F1/se008e0f1.tar.gz"
  version "0.0.8E0F1"
  sha256 "e9bd3672c866acc5a0d75e245c190c689956319f192cb5d23ea924dd77e426c3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "30e0e2d8fe730840a1dd4ba47de2ed5fbde1382dac14cefc5c53217c9821e7ea" => :sierra
    sha256 "cab51fd281c05ded8dd7ba473a754601a59a4e7f1d2ecbe8c6811e045d4c2a7a" => :el_capitan
    sha256 "436c0e1dbabf4c5699ab5c8d6b86340e1c092f7e4a19b70d6de01f5d6bffb48a" => :yosemite
  end

  skip_clean "slashemdir/save"

  depends_on "pkg-config" => :build

  # Fixes compilation error in OS X: https://sourceforge.net/p/slashem/bugs/896/
  patch :DATA

  # Fixes user check on older versions of OS X: https://sourceforge.net/p/slashem/bugs/895/
  # Fixed upstream: http://slashem.cvs.sourceforge.net/viewvc/slashem/slashem/configure?r1=1.13&r2=1.14&view=patch
  patch :p0 do
    url "https://gist.githubusercontent.com/mistydemeo/76dd291c77a509216418/raw/65a41804b7d7e1ae6ab6030bde88f7d969c955c3/slashem-configure.patch"
    sha256 "c91ac045f942d2ee1ac6af381f91327e03ee0650a547bbe913a3bf35fbd18665"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-mandir=#{man}",
                          "--with-group=#{Etc.getpwuid.gid}",
                          "--with-owner=#{Etc.getpwuid.name}",
                          "--enable-wizmode=#{Etc.getpwuid.name}"
    system "make", "install"

    man6.install "doc/slashem.6", "doc/recover.6"
  end
end

__END__
diff --git a/win/tty/termcap.c b/win/tty/termcap.c
index c3bdf26..8d00b11 100644
--- a/win/tty/termcap.c
+++ b/win/tty/termcap.c
@@ -960,7 +960,7 @@ cl_eos()			/* free after Robert Viduya */

 #include <curses.h>

-#if !defined(LINUX) && !defined(__FreeBSD__)
+#if !defined(LINUX) && !defined(__FreeBSD__) && !defined(__APPLE__)
 extern char *tparm();
 #endif

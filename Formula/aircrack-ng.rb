class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"

  # If you compile aircrack-ng from source using Gmake, it is compatible with OS X
  # Issue fixed by compiling aircrack-ng from source
  url "http://download.aircrack-ng.org/aircrack-ng-1.2-rc4.tar.gz"
  sha256 "d93ac16aade5b4d37ab8cdf6ce4b855835096ccf83deb65ffdeff6d666eaff36"

  bottle do
    cellar :any
    sha256 "5b9fb699f8a3c64828ab9c696877ce7755d5a939f1b7f87e70f13a58b8d7f7c8" => :el_capitan
    sha256 "3f2a9c5b6b5504938b7bd68c5f42659f35ea5beef4852b5ca0aea5dabc719d98" => :yosemite
    sha256 "f8c632b9227bc7f7b3429c1ce6d9c85cb21536137cf016a68ebdc46df9bb8dc4" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "openssl"
  depends_on "pcre"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    system "make", "xcode=true", "sqlite=true", "experimental=true", "pcre=true"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  def caveats; <<-EOS.undent
    Run `airodump-ng-oui-update` install or update the Airodump-ng OUI file.
    EOS
  end

  test do
    system "#{bin}/aircrack-ng", "--help"
  end
end

__END__
--- a/scripts/airodump-ng-oui-update
+++ b/scripts/airodump-ng-oui-update
@@ -7,25 +7,6 @@
 OUI_PATH="/usr/local/etc/aircrack-ng"
 AIRODUMP_NG_OUI="${OUI_PATH}/airodump-ng-oui.txt"
 OUI_IEEE="${OUI_PATH}/oui.txt"
-USERID=""
-
-
-# Make sure the user is root
-if [ x"`which id 2> /dev/null`" != "x" ]
-then
-	USERID="`id -u 2> /dev/null`"
-fi
-
-if [ x$USERID = "x" -a x$UID != "x" ]
-then
-	USERID=$UID
-fi
-
-if [ x$USERID != "x" -a x$USERID != "x0" ]
-then
-	echo Run it as root ; exit ;
-fi
-

 if [ ! -d "${OUI_PATH}" ]; then
   mkdir -p ${OUI_PATH}

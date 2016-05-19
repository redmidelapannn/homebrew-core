class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"

  # We can't update this due to linux-only dependencies in >1.1.
  # See https://github.com/Homebrew/homebrew/issues/29450
  url "https://download.aircrack-ng.org/aircrack-ng-1.1.tar.gz"
  sha256 "b136b549b7d2a2751c21793100075ea43b28de9af4c1969508bb95bcc92224ad"
  revision 2

  bottle do
    cellar :any
    revision 1
    sha256 "8b237d8f44d6e3454a3d3492a373d8447e3786e0582f9a52e4a34e312cc2f3f1" => :el_capitan
    sha256 "f9b6f2354db33166f025ca33a39ff07f1d61c05ead07bb6549cf0e1986e14d3e" => :yosemite
    sha256 "331e62d8d8a042708eeaf299bf60b1e38abd75b7f1bfd06c51f3957fa5329ff3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "openssl"

  # Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA

  def install
    # Fix incorrect OUI url
    inreplace "scripts/airodump-ng-oui-update",
      "http://standards.ieee.org/regauth/oui/oui.txt",
      "http://standards-oui.ieee.org/oui.txt"

    system "make", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  def caveats; <<-EOS.undent
    Run `airodump-ng-oui-update` install or update the Airodump-ng OUI file.
    EOS
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


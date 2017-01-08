class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "https://aircrack-ng.org/"
  revision 2

  stable do
    url "https://download.aircrack-ng.org/aircrack-ng-1.1.tar.gz"
    sha256 "b136b549b7d2a2751c21793100075ea43b28de9af4c1969508bb95bcc92224ad"
    # Remove root requirement from OUI update script. See:
    # https://github.com/Homebrew/homebrew/pull/12755
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 "04c9f23154886f57655b61b2cc3f609f3c58146c772885e3383dd4943b3c0e51" => :sierra
    sha256 "24517bef94eb50fb8d2df02d39d7e113849a89c4a9df791ed716a69ca65e3931" => :el_capitan
    sha256 "8c703bdb2f8fd51a76edcefdfcd72f184e86f06adbb90cf43a1ead6a6504da7b" => :yosemite
  end

  devel do
    url "https://download.aircrack-ng.org/aircrack-ng-1.2-rc4.tar.gz"
    sha256 "d93ac16aade5b4d37ab8cdf6ce4b855835096ccf83deb65ffdeff6d666eaff36"
    patch do
      # The url will be replaced with one on formula-patch once PR on formula-patch has merged
      url "https://github.com/equal-l2/formula-patches/raw/aircrack-ng/aircrack-ng/aircrack-ng-devel.patch"
      sha256 "9fa96d2633046622779dbe431572f2888329cfda6bc73fbb959d6a7c2d712c32"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "openssl"

  def install
    unless build.devel?
      # Fix incorrect OUI url
      inreplace "scripts/airodump-ng-oui-update",
        "http://standards.ieee.org/regauth/oui/oui.txt",
        "http://standards-oui.ieee.org/oui.txt"
    end

    system "make", "CC=#{ENV.cc}"
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


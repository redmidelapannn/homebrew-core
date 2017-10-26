class Softhsmv2 < Formula
  desc "SoftHSM version 2"
  homepage "http://www.softhsm.org/"
  url "https://github.com/opendnssec/SoftHSMv2/archive/2.3.0.tar.gz"
  sha256 "9fa32236cb7a344aaea86f44f67a2178e64e8a753073fcf4b88bed437bc1440e"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "cppunit" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "sqlite"

  def install
    system "sh", "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-objectstore-backend-db",
                          "--with-openssl=/usr/local/opt/openssl",
                          "--with-sqlite3=/usr/local/opt/sqlite",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    mkdir "#{prefix}/var/lib/softhsm/tokens/"
    system "#{bin}/softhsm2-util", "--init-token", "--free", "--label", "test", "--so-pin", "1234", "--pin", "1234"
  end
end

class Softhsm2 < Formula
  desc "Cryptographic store accessible through a PKCS #11"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.3.0.tar.gz"
  sha256 "5ed604c89a3a6ef9d7d1ee92c28a2c4b3cd1f86f302c808e2d12c8f39aa2c127"

  bottle do
    sha256 "33025dc69c03f818ca7927a20f7bac22cae63bbd1923af12fddbbfda5e798ba9" => :high_sierra
    sha256 "0bc4887d254cf2bb6b0ac3f5c8ac45d93ce7cbb58edc823ba76efa83030980e8" => :sierra
    sha256 "236985066f3b7be24cb17bfdc982896416fd190396ba445fc438697be957546a" => :el_capitan
  end

  depends_on "cppunit" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-objectstore-backend-db",
                          "--with-migrate",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"

    system "make", "install"
  end

  def post_install
    (var/"lib/softhsm/softhsm").mkpath
  end

  test do
    system "#{bin}/softhsm2-util", "--init-token", "--free",
                                   "--label", "test",
                                   "--so-pin", "1234",
                                   "--pin", "1234"
  end
end

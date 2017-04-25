class Geoip < Formula
  desc "This library is for the GeoIP Legacy format (dat)"
  homepage "https://github.com/maxmind/geoip-api-c"
  url "https://github.com/maxmind/geoip-api-c/releases/download/v1.6.10/GeoIP-1.6.10.tar.gz"
  sha256 "cb44e0d0dbc45efe2e399e695864e58237ce00026fba8a74b31d85888c89c67a"

  head "https://github.com/maxmind/geoip-api-c.git"

  bottle do
    rebuild 1
    sha256 "087365349c8cfbae8186c773bc08a32c1b1367cbbcd388a1bf21b44427ff6b93" => :sierra
    sha256 "b4d7ddb292a48857d00d593af3cdba83ef5be52799ba50ba9b8796068b0b707d" => :el_capitan
    sha256 "199e7ffb1286ff94e796ffd2c5d325963c88bd0a8f2a33fdb93a372fa856220a" => :yosemite
  end

  depends_on "geoipupdate" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    geoip_data = Pathname.new "#{var}/GeoIP"
    geoip_data.mkpath

    # Since default data directory moved, copy existing DBs
    legacy_data = Pathname.new "#{HOMEBREW_PREFIX}/share/GeoIP"
    cp Dir["#{legacy_data}/*"], geoip_data if legacy_data.exist?

    full = Pathname.new "#{geoip_data}/GeoIP.dat"
    ln_s "GeoLite2-Country.dat", full unless full.exist? || full.symlink?
    full = Pathname.new "#{geoip_data}/GeoIPCity.dat"
    ln_s "GeoLite2-City.dat", full unless full.exist? || full.symlink?
  end

  test do
    system "curl", "-O", "https://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
    system "gunzip", "GeoIP.dat.gz"
    system "#{bin}/geoiplookup", "-f", "GeoIP.dat", "8.8.8.8"
  end
end

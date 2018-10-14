class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.2.tar.gz"
  sha256 "6ba9f66540ea58fc2c17f175265f9ed76d74a8432eeac1182b74ebf4f2cd3414"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    rebuild 2
    sha256 "bd348a09791ab920c4beeb592a243ce306c0bdc4c7d5acc3fd8738933a927478" => :mojave
    sha256 "9ae078df13abb3aa7428931287c1e134091dac25a9f8d4b949730f11286c7330" => :high_sierra
    sha256 "d1d370a5edf14512bbde82a870fecd43fdc34ff7352f2e1ae194c9284318868e" => :sierra
  end

  option "with-libmaxminddb", "Enable IP location information using enhanced GeoIP2 databases"

  deprecated_option "enable-geoip" => "with-libmaxminddb"
  deprecated_option "with-geoip" => "with-libmaxminddb"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "tokyo-cabinet"
  depends_on "libmaxminddb" => :optional

  def install
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
    ]

    args << "--enable-geoip=mmdb" if build.with? "libmaxminddb"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"access.log").write \
      '127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" ' \
      '"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) ' \
      'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"'

    output = shell_output \
      "#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y " \
      "--log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' " \
      "-f access.log -o json 2>/dev/null"

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"].first["data"]
  end
end

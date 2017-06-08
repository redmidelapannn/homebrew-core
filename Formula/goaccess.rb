class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.2.tar.gz"
  sha256 "6ba9f66540ea58fc2c17f175265f9ed76d74a8432eeac1182b74ebf4f2cd3414"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    rebuild 2
    sha256 "109a263597d5fe03b9d44e773bbcd95d0fcbfc71a731143d93a1278b7366cc9b" => :sierra
    sha256 "bf40c356780add9fa3fbaa3d8e89ed1fc29bce782fede7f1ed454052f02888a4" => :el_capitan
    sha256 "961f59c23618c40a9a54d6cc06b0717a4bffaa649853acd53fb0a130b74af9ec" => :yosemite
  end

  option "with-libmaxminddb", "Enable IP location information using enhanced GeoIP2 databases"

  deprecated_option "enable-geoip" => "with-libmaxminddb"
  deprecated_option "with-geoip" => "with-libmaxminddb"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libmaxminddb" => :optional
  depends_on "tokyo-cabinet"

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
    (testpath/"access.log").write <<-EOS.undent
      127.0.0.1 - - [04/May/2015:15:48:17 +0200] "GET / HTTP/1.1" 200 612 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36"
    EOS

    output = shell_output("#{bin}/goaccess --time-format=%T --date-format=%d/%b/%Y --log-format='%h %^[%d:%t %^] \"%r\" %s %b \"%R\" \"%u\"' -f access.log -o json 2>/dev/null")

    assert_equal "Chrome", JSON.parse(output)["browsers"]["data"][0]["data"]
  end
end

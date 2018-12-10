class Goaccess < Formula
  desc "Log analyzer and interactive viewer for the Apache Webserver"
  homepage "https://goaccess.io/"
  url "https://tar.goaccess.io/goaccess-1.3.tar.gz"
  sha256 "8c775c5c24bf85a933fd6f1249004847342d6542aa533e4ec02aaf7be41d7b9b"
  head "https://github.com/allinurl/goaccess.git"

  bottle do
    sha256 "1f42697cc9535069b9170292899c6113b523ad858c1b8ab495787ae3b4b37672" => :mojave
    sha256 "14ab4039f528c637bdc71617abc0adffadbd27152071383957bee75ca01b888c" => :high_sierra
    sha256 "cec450aa6338f7b7e320a8cbc7b709c821ad0ee9a573122cf4a5dd9ade910428" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libmaxminddb"
  depends_on "tokyo-cabinet"

  def install
    system "autoreconf", "-vfi"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-tcb=btree
      --enable-geoip=mmdb
    ]

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

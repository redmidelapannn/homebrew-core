class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.11.tar.bz2"
  mirror "http://ftp.cc.uoc.gr/mirrors/ftp.freeradius.org/freeradius-server-3.0.11.tar.bz2"
  sha256 "2b6109b61fc93e9fcdd3dd8a91c3abbf0ce8232244d1d214d71a4e5b7faadb80"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    revision 1
    sha256 "2206c322eea31933501066983c5a9919e2f644d33ff4a91f75ea347b843e04e2" => :el_capitan
    sha256 "e0dda7fe1f0dfe29addb83e00a5a8c51f25a745a79b7fe79c99ed5cf55387654" => :yosemite
    sha256 "06c773827cbe3f28df8fde1952aee07aa299aa0af29dd369f64b41987487eb50" => :mavericks
  end

  depends_on "openssl"
  depends_on "talloc"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl"].opt_include}
      --with-openssl-libraries=#{Formula["openssl"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match /77C8009C912CFFCF3832C92FC614B7D1/, shell_output("#{bin}/smbencrypt homebrew")
  end
end

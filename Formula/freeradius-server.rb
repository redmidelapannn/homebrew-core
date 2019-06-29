class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_19.tar.gz"
  sha256 "34c50ac47a683b13eae1a02f2d0263c0bd51a83f01b99c02c5fe25df07a1ee77"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    rebuild 1
    sha256 "54835630ec83e33faabcdd8dc59cbc571bf960d3788ac6b28a6533639442cdff" => :mojave
    sha256 "09ee5d3e29abcb87788abab3be15a7bc36c1b3bca318feaa2c49b6aec3fb5890" => :high_sierra
    sha256 "b9fd781940d774d470af607d328c5b72758c4fdb2525c49dffa6b044c3f21b5a" => :sierra
  end

  depends_on "openssl"
  depends_on "talloc"
  uses_from_macos "perl"

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
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end

class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_17.tar.gz"
  sha256 "5b2382f08c0d9d064298281c1fb8348fc13df76550ce7a5cfc47ea91361fad91"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    rebuild 1
    sha256 "ad95e60c9e4216ae0d52c0edcede3928350175c092087437133c0799e378bc84" => :mojave
    sha256 "64d5190f02d7ded70e8065fe2234c3ac1e6881aebf41c8527d9d1e1f074ddcf0" => :high_sierra
    sha256 "146c07f0631a27c974fce14e4974ecfa0278f6e8fc64a30e24f9b21367dc4f71" => :sierra
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
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end

class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/release_3_0_21.tar.gz"
  sha256 "b2014372948a92f86cfe2cf43c58ef47921c03af05666eb9d6416bdc6eeaedc2"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "84f7ec5ad6f8a9ba51656faa9dca16cc123564d85c16e3fba8748d8619ecfb5a" => :catalina
    sha256 "4381db331c6b95e2a46aec479800526e6a3811908deec59ff842e97cda368b1d" => :mojave
    sha256 "15ae1b8144dc0bf2e8e5603d6727d32530dcc32a893191f02b229d31332d3aa1" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "talloc"

  uses_from_macos "perl"
  uses_from_macos "readline"
  uses_from_macos "sqlite"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl@1.1"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@1.1"].opt_lib}
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

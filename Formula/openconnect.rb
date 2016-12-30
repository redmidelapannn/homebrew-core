class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "http://www.infradead.org/openconnect.html"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-7.08.tar.gz"
  sha256 "1c44ec1f37a6a025d1ca726b9555649417f1d31a46f747922b84099ace628a03"
  revision 1

  bottle do
    sha256 "7db863bf6d407ef21dceb509514796c34be092340bfa26a12190b6b296952306" => :sierra
    sha256 "6d2f9df3e225a48ccb684a10cd27d16953c34ae90158cccacfc59799e55dec55" => :el_capitan
    sha256 "d5d4fb1bda2cef3c4071223266055918aa6b28067ebf4ab48da3e5791f2ce7b9" => :yosemite
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Use of GnuTLS is currently preferred as this results in a complete feature
  # set, i.e. DTLS MTU detection.
  option "with-openssl", "Use OpenSSL instead of GnuTLS"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls" if build.without? "openssl"
  depends_on "openssl" => :optional
  depends_on "oath-toolkit" => :optional
  depends_on "stoken" => :optional

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/6e04e0bbb66c0bf0ae055c0f4e58bea81dbb5c3c:/vpnc-script"
    sha256 "48b1673e1bfaacbfa4e766c41e15dd8458726cca8f3e07991d078d0d5b7c55e9"
  end

  def install
    etc.install resource("vpnc-script")
    chmod 0755, "#{etc}/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc-script
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "AnyConnect VPN", pipe_output("#{bin}/openconnect 2>&1")
  end
end

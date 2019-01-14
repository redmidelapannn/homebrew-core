class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.01.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.01.tar.gz"
  sha256 "48868a4f99c81a7474d87fbabb41b8eaa7d32b54771c9f23a7aea72d9cd626fd"
  revision 1

  bottle do
    sha256 "10f9de3eb8c792c0dae1bcf78eaf898faa82ea51ac3f088a6ebeda7f7fd02b15" => :mojave
    sha256 "a9ee397bebe7f341342ae3e940a33a12436510b90a50d08c013cc3737f40c6e1" => :high_sierra
    sha256 "4c8a4f1223c7f7194ff08f61ed0b8d9b7be29e9d1e4893d4203c020afa1f6e61" => :sierra
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "stoken"

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
    assert_match "Open client for multiple VPN protocols", pipe_output("#{bin}/openconnect 2>&1")
  end
end

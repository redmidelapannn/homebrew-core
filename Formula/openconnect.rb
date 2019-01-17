class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.02.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.02.tar.gz"
  sha256 "1ca8f2c279f12609bf061db78b51e5f913b3bce603a0d4203230a413d8dfe012"

  bottle do
    rebuild 1
    sha256 "0ea8689b36969a5581a5505570ffa79b5ef02634c4bc84b950db00eb334d1a44" => :mojave
    sha256 "eb4bed3fc5aa8e96ac2b60cfe42363c329fc6b22a615d6ff7b7e12e344a54266" => :high_sierra
    sha256 "27d1fa4c9216dde4067451b8fe8e058c1e48ae01fc50b7148a85275909012809" => :sierra
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

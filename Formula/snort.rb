class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.13.tar.gz"
  sha256 "31447393d15286b848810dd78ab2cb3ad231fcd1f1663f959587690eeea75413"

  bottle do
    cellar :any
    sha256 "a88664fb7e08828749d973c0e3d112d475e8ca0f453573625b7e01f7dbc17b68" => :mojave
    sha256 "ec6d4b24c30dd55c2e55352b08e5b89ab05f493845a281e660c068b12f91c5fa" => :high_sierra
    sha256 "fc6e32c8ae4360824571755004c7395c2dda524b8df6b1f2452eb11aadfe805e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "libdnet"
  depends_on "libpcap"
  depends_on "luajit"
  depends_on "nghttp2"
  depends_on "openssl"
  depends_on "pcre"

  def install
    openssl = Formula["openssl"]
    libpcap = Formula["libpcap"]

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/snort
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-active-response
      --enable-flexresp3
      --enable-gre
      --enable-mpls
      --enable-normalizer
      --enable-react
      --enable-reload
      --enable-sourcefire
      --enable-targetbased
      --with-openssl-includes=#{openssl.opt_include}
      --with-openssl-libraries=#{openssl.opt_lib}
      --with-libpcap-includes=#{libpcap.opt_include}
      --with-libpcap-libraries=#{libpcap.opt_lib}
    ]

    system "./configure", *args
    system "make", "install"

    rm Dir[buildpath/"etc/Makefile*"]
    (etc/"snort").install Dir[buildpath/"etc/*"]
  end

  def caveats; <<~EOS
    For snort to be functional, you need to update the permissions for /dev/bpf*
    so that they can be read by non-root users.  This can be done manually using:
        sudo chmod o+r /dev/bpf*
    or you could create a startup item to do this for you.
  EOS
  end

  test do
    system bin/"snort", "-V"
  end
end

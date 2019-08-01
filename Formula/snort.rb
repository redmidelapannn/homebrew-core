class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.13.tar.gz"
  sha256 "31447393d15286b848810dd78ab2cb3ad231fcd1f1663f959587690eeea75413"

  bottle do
    cellar :any
    sha256 "71f678bba506371cfad02dc981b5e36094feeb9daeaad686f458b767a4ae16c3" => :mojave
    sha256 "dcc43887a39bca8646c585df4f9785308bffbedc572bca877c06f0f4b180fbb6" => :high_sierra
    sha256 "6f8502e291ebd4fd51b50e83bb2f7d536dd19a02b37006a8f071c0bba1bc18d8" => :sierra
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
      --disable-control-socket
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

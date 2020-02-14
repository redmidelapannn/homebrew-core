class Snort < Formula
  desc "Flexible Network Intrusion Detection System"
  homepage "https://www.snort.org"
  url "https://www.snort.org/downloads/snort/snort-2.9.15.1.tar.gz"
  sha256 "2cccfc1d1a706586cd47ae9f085a7d5e4e36390b8e9c28cd2020b4b5b587f6c3"

  bottle do
    cellar :any
    sha256 "53e1247bb9a151ccf43b385ca10628d05dc1657ebe4f71b4fd8ad313e3fe893e" => :catalina
    sha256 "2d0392a73894fa8f7cc79633be0fc41ebd4296b221fc4b90a6239106a9ada883" => :mojave
    sha256 "f53bdd39a4e99c0c488aadbf09d2a4529a8bb43e531a6612fb58b9cd27b212aa" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "daq"
  depends_on "libdnet"
  depends_on "libpcap"
  depends_on "luajit"
  depends_on "nghttp2"
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    openssl = Formula["openssl@1.1"]
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

class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "https://ftpmirror.gnu.org/commonc++/ucommon-6.2.2.tar.gz"
  sha256 "1ddcef26dc5c930225de6ab9adc3c389cb3f585eba0b0f164206f89d2dafea66"
  revision 1

  bottle do
    revision 1
    sha256 "4270a1a0c2e2ac14bc97c49f5a3a8a1d8478e4555d105a34c0a21c00bc3cf534" => :el_capitan
    sha256 "e0ed0421e858e792c5260e131e0db23cbd785107199ca36e1c8eb0a63ef51235" => :yosemite
    sha256 "a6f568ca15e0901afc1a50909f2b428ebc2d88f349c3445eef6ac2b2e9628d93" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    # Replace the ldd with OS X's otool. This is unlikely to be merged upstream.
    # Emailed upstream (dyfet at gnu dot org) querying this on 25/11/14.
    # It generates a very minor runtime error without the inreplace, so...
    inreplace "commoncpp-config.in", "ldd /bin/sh", "otool -L /bin/sh"
    inreplace "ucommon-config.in", "ldd /bin/sh", "otool -L /bin/sh"

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules", "--enable-socks",
                          "--with-sslstack=gnutls", "--with-pkg-config"
    system "make", "install"
  end

  test do
    system "#{bin}/ucommon-config", "--libs"
  end
end

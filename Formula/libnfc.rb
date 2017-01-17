class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "http://nfc-tools.org"
  url "https://bintray.com/artifact/download/nfc-tools/sources/libnfc-1.7.1.tar.bz2"
  sha256 "945e74d8e27683f9b8a6f6e529557b305d120df347a960a6a7ead6cb388f4072"

  bottle do
    rebuild 1
    sha256 "9b7144262e4cb6001165087effd315097d49636c6e83087d2e8c9f084f900ff6" => :sierra
    sha256 "773095ea7cb60081b755f6366aa30dad8114c913d69438a134f6561d68edc982" => :el_capitan
    sha256 "6375e14a0e676bae2407f3a13c9da8d7cd45e719be78c49a3f4fd8874fe815fd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-serial-autoprobe",
                          "--with-drivers=all"
    system "make", "install"
    (prefix/"etc/nfc/libnfc.conf").write "allow_intrusive_scan=yes"
  end

  test do
    system "#{bin}/nfc-list"
  end
end

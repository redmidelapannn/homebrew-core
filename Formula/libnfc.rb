class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "https://github.com/nfc-tools/libnfc"
  url "https://bintray.com/artifact/download/nfc-tools/sources/libnfc-1.7.1.tar.bz2"
  sha256 "945e74d8e27683f9b8a6f6e529557b305d120df347a960a6a7ead6cb388f4072"

  bottle do
    rebuild 1
    sha256 "9841eaad09019a00406d509922fd6b9c3f104ac132fb75211eb92c1399640054" => :mojave
    sha256 "f40349e8d6a13842c3c5819e45de698e18d9717013d74bef7819acac5d92af4f" => :high_sierra
    sha256 "f54a004ccea3be3832e52ef2237489eb7d4a2841ca732aa3302e0a24e005940c" => :sierra
  end

  head do
    url "https://github.com/nfc-tools/libnfc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "autoreconf", "-vfi" if build.head?
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

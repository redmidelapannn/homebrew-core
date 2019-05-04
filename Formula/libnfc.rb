class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "http://nfc-tools.org"
  url "https://bintray.com/artifact/download/nfc-tools/sources/libnfc-1.7.1.tar.bz2"
  sha256 "945e74d8e27683f9b8a6f6e529557b305d120df347a960a6a7ead6cb388f4072"

  bottle do
    rebuild 1
    sha256 "027576ba6530cf1195113a62206ba4ae18434572d3571b172119bef4fa965169" => :mojave
    sha256 "3aef091d5282c933572ebde85c6addd964795612548c51c9d9cbd082b9d0580e" => :high_sierra
    sha256 "df40ac32114cdb37930329b71ce59b52e33443b9b994bd01a54e759b18c2da02" => :sierra
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

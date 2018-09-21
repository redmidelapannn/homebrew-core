class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod/pianod-176.tar.gz"
  sha256 "4f3be12daef1adb3bcbbcf8ec529abf0ac018e03140be9c5b0f1203d6e1b9bf0"
  revision 1

  bottle do
    rebuild 1
    sha256 "5b44dab604da21fd31133603f3bcc3fff424f8e3584415b5d02afac386b7e2fc" => :mojave
    sha256 "f94c681e9afc8b159b054816ea60f23eb25b6166265d7ca5145cfc2ce003f058" => :high_sierra
    sha256 "b515ea8aa1435fdba11bed91256cadd3f857e6c8be6777227321343294bf3665" => :sierra
    sha256 "5cf10998701e37c3706aacca61dc925d2dd65ade0b1ba1115460a25ea464f698" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "mad"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end

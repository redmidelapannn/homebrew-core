class Libidn < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.0.2.tar.gz"
  sha256 "8cd62828b2ab0171e0f35a302f3ad60c3a3fffb45733318b3a8205f9d187eeab"

  bottle do
    cellar :any
    sha256 "b8852142563c1c8bafafe14fd466300618ad96686d4e8d75f39044eb91f29e3a" => :sierra
    sha256 "3009fcc7653f0261f068fcad33d1e4f28193a58c6e97ec5b9c9cd1b033719055" => :el_capitan
    sha256 "285f014909388247cff36ad506ddca14350696506a06d0f59aa4b6cbe84b74d0" => :yosemite
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "gengetopt" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn2", "räksmörgås.se", "blåbærgrød.no"

    # Compatibility test for libidn 1.x functions.
    (testpath/"test.c").write <<-EOS.undent
      #include <idn2.h>
      int main() {
        return idna_to_ascii_lz(NULL, NULL, 0);
      }
    EOS
    system ENV.cc, "test.c", "-lidn2", "-o", "test"
    system "./test"
  end
end

class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.1.tar.bz2"
  sha256 "efc20361d6e43f9ff74de5f4d86c2ce9c677693f5da08b0a88d603b7475a508d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a1f43bcfac6adc17939677ccb624761957f25744c2d7dcbfb5b65938d6171594" => :sierra
    sha256 "a1db71c8145c7e0f998fe314d32aee524b4c8ccc53f99232aba09b4e7590887d" => :el_capitan
    sha256 "7df1aab5c6e50646b1b63fac9cd1455129d25fe1620a481a8868fb2538015f5e" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                   "-lwpd-0.10", "-I#{include}/libwpd-0.10"
    system "./test"
  end
end

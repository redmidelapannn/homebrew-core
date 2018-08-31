class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "https://libwpg.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpg-0.3.2.tar.xz"
  sha256 "57faf1ab97d63d57383ac5d7875e992a3d190436732f4083310c0471e72f8c33"

  bottle do
    cellar :any
    rebuild 1
    sha256 "711e1aa98622505d94151d7b853ba216f404c634df7b906fd8668df89404afc0" => :mojave
    sha256 "866a30b01d916e3ccaba68a72c6842fe980b93cc8665c40dc8e3595659ae8bd6" => :high_sierra
    sha256 "fb1216b885a466a631b80c54d116634ea6346326cb1eb51ba21379b22509a25f" => :sierra
    sha256 "f9128f06a9bc441e5928fe949d8561d7d665c658cea698213c0b98d611c58ac9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwpg/libwpg.h>
      int main() {
        return libwpg::WPG_AUTODETECT;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpg-0.3",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpg-0.3", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end

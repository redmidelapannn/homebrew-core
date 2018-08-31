class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.2.tar.xz"
  sha256 "323f68beaf4f35e5a4d7daffb4703d0566698280109210fa4eaa90dea27d6610"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bfe2d2a70840363abd31276738e2ee9a5544c04b4a49a2f99f06b31256939328" => :mojave
    sha256 "ac3e900fa0ca227d02eb7d6aa0baef25b1961ca9fd71bd63dda9ca56b17dc6d4" => :high_sierra
    sha256 "1c0d3ae7c38f755c42b2688df2d7911a3c4becb2d154683bdb1bd8af609d2692" => :sierra
    sha256 "c6f27dfb2a99b9957d52d8d0256a413fa8ea947976c5c300ebec588a8b26fd57" => :el_capitan
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
    (testpath/"test.cpp").write <<~EOS
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpd-0.10",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpd-0.10", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end

class Libpagemaker < Formula
  desc "Imports file format of Aldus/Adobe PageMaker documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"
  url "https://dev-www.libreoffice.org/src/libpagemaker/libpagemaker-0.0.3.tar.xz"
  sha256 "d896dc55dafd84ee3441e0ca497b810809f9eea44805a495c3843412309036d6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3b0ad0c140d81c2cde2a302e55f2d93aca5648de794a7f4415b0dcaf25898f08" => :sierra
    sha256 "1f6badf37ab6c9b5d77f8fd5391e812f27b94ddd012b39f0252023d9a120b1e5" => :el_capitan
    sha256 "5f39f4aa904781c975d287617c0eecb34238f9deaac6c013a52600d036a4c145" => :yosemite
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libpagemaker/libpagemaker.h>
      int main() {
        libpagemaker::PMDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libpagemaker-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lpagemaker-0.0"
    system "./test"
  end
end

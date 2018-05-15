class Libcsv < Formula
  desc "CSV library in ANSI C89"
  homepage "https://sourceforge.net/projects/libcsv/"
  url "https://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.3/libcsv-3.0.3.tar.gz"
  sha256 "d9c0431cb803ceb9896ce74f683e6e5a0954e96ae1d9e4028d6e0f967bebd7e4"

  bottle do
    cellar :any
    rebuild 3
    sha256 "91a4a3af929a673ba83e611034f11663084cc779761f8c4093fe556155633486" => :high_sierra
    sha256 "9444ef5b1400734483a28c22fc32ddaf9e6dbf03abc58632fd641ca5876d57b5" => :sierra
    sha256 "f903aa99e7081488d783c97eabd4917271607db68005d4fb2364ec90d7c772be" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <csv.h>
      int main(void) {
        struct csv_parser p;
        csv_init(&p, CSV_STRICT);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcsv", "-o", "test"
    system "./test"
  end
end

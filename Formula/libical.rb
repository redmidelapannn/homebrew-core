class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/archive/v3.0.6.tar.gz"
  sha256 "fd2404a3df42390268e9fb804ef9f235e429b6f0da8992a148cbb3614946d99b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2f52a40ba0880933e30ea8f452fc8b3ef8d6c39d46aa38652f2f4bf5c2e907ae" => :catalina
    sha256 "aab3f41a3107c6aeb035404a08753e8af05b2ca8c43aca4e2e0b6e2baf72e014" => :mojave
    sha256 "abee9f260f9eef896c3e27c06288b4e0b95d73d8e2678347d19ea65fb11abc24" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"
  uses_from_macos "libxml2"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DENABLE_GTK_DOC=OFF",
                         "-DSHARED_ONLY=ON",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end

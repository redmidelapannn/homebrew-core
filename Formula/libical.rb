class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/archive/v3.0.6.tar.gz"
  sha256 "fd2404a3df42390268e9fb804ef9f235e429b6f0da8992a148cbb3614946d99b"
  revision 1

  bottle do
    cellar :any
    sha256 "2e8818f77a399557be6a14156ea99048129843eee34d91116d95e05f4a7ac448" => :catalina
    sha256 "eaa48d43b056444dc537ae537296e0c7c7e07faa705ec9f3b621d05402f9c5ed" => :mojave
    sha256 "339d61732080126041a48ffaf9d90218ad1c5e99fa64333baeeda922b1c3c67c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"

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

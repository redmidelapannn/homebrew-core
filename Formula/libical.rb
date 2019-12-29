class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/archive/v3.0.7.tar.gz"
  sha256 "546115fe53dc8800e79478211efa5c2cfe7cae8e34cff54fbc14b42cd98e4fe5"
  revision 1

  bottle do
    cellar :any
    sha256 "4c3f48ba10e7985f4892d1bbd24b73b89ac49e945fb295a256c4da25d715ee42" => :catalina
    sha256 "99f27d0c4adf816adefe848a3d29a6633204e677ab1e88e976a9f8cf906acfc8" => :mojave
    sha256 "dfc208a7c679dfdf92282fbeb4ed4f029303fcdab13c1f6859e91f31f4017fac" => :high_sierra
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

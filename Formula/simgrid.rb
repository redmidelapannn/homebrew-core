class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "https://simgrid.org/"
  url "https://gforge.inria.fr/frs/download.php/file/37602/SimGrid-3.20.tar.gz"
  sha256 "4d4757eb45d87cf18d990d589c31d223b0ea8cf6fcd8c94fca4d38162193cef6"

  bottle do
    rebuild 1
    sha256 "e6376a0a88f8adc3eb057d91774d0818848f8745c091552a48c82ba9adf38347" => :mojave
    sha256 "bef96ac718282e1c03834a50d948d625fd81233de384dfdfdf19abf546e5ac73" => :high_sierra
    sha256 "79ccc124da034e0db5b2f589c94a84ca797207a726520b9c37f58b31b84c0a4f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "graphviz"
  depends_on "pcre"
  depends_on "python"

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <simgrid/msg.h>

      int main(int argc, char* argv[]) {
        printf("%f", MSG_get_clock());
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimgrid",
                   "-o", "test"
    system "./test"
  end
end

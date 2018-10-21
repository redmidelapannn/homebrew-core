class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37602/SimGrid-3.20.tar.gz"
  sha256 "4d4757eb45d87cf18d990d589c31d223b0ea8cf6fcd8c94fca4d38162193cef6"

  bottle do
    rebuild 1
    sha256 "1d7b9eb544d3839c0f6ad6e958ebcb0e35042e68b0464aadc907b23be3be0182" => :mojave
    sha256 "506beed39e34164877d1be6a56d376acf7febe75933f99ac686961b46fcdc2f4" => :high_sierra
    sha256 "ef32b071d6bb42032e5a1905a398685976c3576d03d7e069c610112dc3b150d3" => :sierra
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

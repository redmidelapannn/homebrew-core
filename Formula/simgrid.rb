class Simgrid < Formula
  desc "Studies behavior of large-scale distributed systems"
  homepage "http://simgrid.gforge.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/file/37455/SimGrid-3.19.1.tar.gz"
  sha256 "a74e69c65660603259a0f417a2e539e8072f2032203795b9e21b3210f5e13a0a"

  bottle do
    rebuild 1
    sha256 "91a2fcae7e0f2b6f13072bb67ce1fcbf74620a59dbc42f000f73b3a1bdaab4a1" => :high_sierra
    sha256 "424e4606da832b010aebf0ea2cf01fde9eaea9516b80d7bac3274119c03ee2d6" => :sierra
    sha256 "79c4a1be7729f216b203cd1709feee3f05b84846ef46c00a9f834f73ab4ac1cf" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "pcre"
  depends_on "python"
  depends_on "graphviz"

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

    system ENV.cc, "test.c", "-lsimgrid", "-o", "test"
    system "./test"
  end
end

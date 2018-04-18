class Fcl < Formula
  desc "Flexible Collision Library"
  homepage "https://flexible-collision-library.github.io/"
  url "https://github.com/flexible-collision-library/fcl/archive/0.5.0.tar.gz"
  sha256 "8e6c19720e77024c1fbff5a912d81e8f28004208864607447bc90a31f18fb41a"
  revision 1

  bottle do
    rebuild 1
    sha256 "84730ea2d1c0b0136e6344d225b706895cc80bfb20925b54bead3828bfbf20f6" => :high_sierra
    sha256 "a73ee70fd1eae3dbbb8ff68f84bf2491c17fc6793311bd6e3ebd29b033e7ff6f" => :sierra
    sha256 "bcc850751696cb44f1383496a9e118fad5fd5b084bcd64966d3d440dfb6d93f2" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libccd"
  depends_on "octomap"

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fcl/shape/geometric_shapes.h>
      #include <cassert>

      int main() {
        assert(fcl::Box(1, 1, 1).computeVolume() == 1);
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lfcl", "-o", "test"
    system "./test"
  end
end

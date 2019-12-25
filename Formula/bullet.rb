class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://github.com/bulletphysics/bullet3/archive/2.89.tar.gz"
  sha256 "621b36e91c0371933f3c2156db22c083383164881d2a6b84636759dc4cbb0bb8"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    sha256 "4a84c4c46c0e22beb53d3ad5df05a4d9ad77b4ccd67e18fd80e0bf3e0a4466a4" => :catalina
    sha256 "5992a44e4d07d35e4f830efff497166e5b732cd73a0b366dcfd9d3609021a80f" => :mojave
    sha256 "0e6dcb027dc75046e518e51f8079d2c367572f3fb7708a8e267536a5dfd6e239" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %W[
      -DBUILD_BULLET2_DEMOS=OFF
      -DBUILD_PYBULLET=OFF
      -DBUILD_UNIT_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{lib}
      -DINSTALL_EXTRA_LIBS=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS

    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", "-lc++", "-o", "test"
    system "./test"
  end
end

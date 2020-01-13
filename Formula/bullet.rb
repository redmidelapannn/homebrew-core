class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  head "https://github.com/bulletphysics/bullet3.git"

  stable do
    url "https://github.com/bulletphysics/bullet3/archive/2.89.tar.gz"
    sha256 "621b36e91c0371933f3c2156db22c083383164881d2a6b84636759dc4cbb0bb8"
  end

  bottle do
    sha256 "712ee03742c631c12e09371dde498adc09ddf663dcc81dd21db05c197f8a125c" => :catalina
    sha256 "8e953f18e783c54aec9d1d222e693d733eb56f76858957816a342e0781ab9a1a" => :mojave
    sha256 "e0338ae102a025cbc74cd51f2aeb68b6703f974964589e83a5145cf7cf0198b0" => :high_sierra
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

class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  head "https://github.com/bulletphysics/bullet3.git"

  stable do
    url "https://github.com/bulletphysics/bullet3/archive/2.89.tar.gz"
    sha256 "621b36e91c0371933f3c2156db22c083383164881d2a6b84636759dc4cbb0bb8"
  end

  bottle do
    sha256 "828dfaf544f3c71ab479de9b077ae5005afb2568efd2b56b60fb94ec17cf2187" => :catalina
    sha256 "f32d521cfa2a534a1d33ab443491cf0f33b9eead49855bc57aada06db551eb46" => :mojave
    sha256 "eb4d9c27f94109bf94fc3fd2ee41e358f47727571c08a5c11088e7436b01fe28" => :high_sierra
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

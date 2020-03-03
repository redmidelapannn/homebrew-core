class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v3.1.0.tar.gz"
  sha256 "6729b260787108462ec6d8954f32a3f11f959ada7eebf1a2a33173b68762849e"

  bottle do
    cellar :any
    sha256 "7f30ee743f4e40f40af4e2d22c357884340f38dc1559761615c429dd142da613" => :catalina
    sha256 "4609895a5b9740905f095c2c69bf1a5cbb1a59182a5dcb6536cc2df152c2c345" => :mojave
    sha256 "87b9f6ae6184e3d35cae0e322bab567789b048c384e92c7f08eb7623ef664306" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args, "-DGLFW_LIBRARY_RELEASE="
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding", "-framework", "OpenGL",
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end

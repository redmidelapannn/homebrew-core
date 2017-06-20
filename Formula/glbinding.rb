class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.3.tar.gz"
  sha256 "48f2e590a4a951005f79fec6c487217aa9b344a33ca1a8d2b7e618f04681ec60"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4999675f635b9ff83a4450bcb2b95883c0c24aa6122fef8df458a5324c2a8558" => :sierra
    sha256 "4abdc6ec4b8c92976f2700be3a1b1c2dd8cc8f42cd5773688fb1c376b945189b" => :el_capitan
    sha256 "4a070dd04c7ffb9d8f089dbb0cd5d05b1c70a354e71f750f14913ac7fce1422d" => :yosemite
  end

  option "with-glfw", "Enable tools that display OpenGL information for your system"
  option "with-static", "Build static instead of shared glbinding libraries"

  depends_on "cmake" => :build
  depends_on "glfw" => :optional
  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args
    args << "-DGLFW_LIBRARY_RELEASE=" if build.without? "glfw"
    args << "-DBUILD_SHARED_LIBS:BOOL=OFF" if build.with? "static"
    system "cmake", ".", *args
    system "cmake", "--build", ".", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glbinding/gl/gl.h>
      #include <glbinding/Binding.h>
      int main(void)
      {
        glbinding::Binding::initialize();
      }
      EOS
    system ENV.cxx, "-o", "test", "test.cpp", "-std=c++11", "-stdlib=libc++",
                    "-I#{include}/glbinding", "-I#{lib}/glbinding", "-framework", "OpenGL",
                    "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end

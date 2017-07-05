class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v2.1.3.tar.gz"
  sha256 "48f2e590a4a951005f79fec6c487217aa9b344a33ca1a8d2b7e618f04681ec60"

  bottle do
    cellar :any
    rebuild 1
    sha256 "293d4f4f8b0ee5accb5b5ded2c6bc35a63b2e47b81b51899fddfed8e6e119f8f" => :sierra
    sha256 "62761f499e580baa0adc170cf92e256ea66ceb4b4725150c9fe4d89b8a847e66" => :el_capitan
    sha256 "47adffc63067bfc4260b2b13893db069f6456f2a7c54a41f55dd066bcc655b4d" => :yosemite
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
                    "-L#{lib}", "-lglbinding", *ENV.cflags.to_s.split
    system "./test"
  end
end

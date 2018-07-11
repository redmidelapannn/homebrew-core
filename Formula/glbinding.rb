class Glbinding < Formula
  desc "C++ binding for the OpenGL API"
  homepage "https://github.com/cginternals/glbinding"
  url "https://github.com/cginternals/glbinding/archive/v3.0.2.tar.gz"
  sha256 "23a383f3ed31af742a4952b6c26faa9c346dd982ba9112c68293a578a6e542ad"

  bottle do
    cellar :any
    sha256 "f5325ac0e9bfc17788f0faa74b6c46ce03a016402f5330c5b6a076815c9dc53e" => :high_sierra
    sha256 "0e7d96a0aa055da6f614f776700b450fa7b966f5f36247c719c25ce7ab8309db" => :sierra
    sha256 "978bde25108f6aaa1a0c943a0d8c6bb9e476560457f6c5092326ac1869da49d1" => :el_capitan
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

class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.2.1.tar.gz"
  sha256 "e10f0de1384d75e6fc210c53e91843f6110d6c4f3afbfb588130713c2f9d8fe8"
  head "https://github.com/glfw/glfw.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c1444f5d32bc3c92629c2fbb85504bafbb5cf6d62a902754e10d3252684d4e16" => :mojave
    sha256 "4205ce7b8cde6e6deb5eb3f4f36ae618015a69e8bb7d3411035eac094a3511e4" => :sierra
    sha256 "3e014b376eb1eaf447ce39bebf00bf56bc1f8d33263017d418d2d9f6ce17b9f1" => :el_capitan
  end

  option "without-shared-library", "Build static library only (defaults to building dylib only)"

  depends_on "cmake" => :build

  deprecated_option "static" => "without-shared-library"

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
    ]
    args << "-DBUILD_SHARED_LIBS=TRUE" if build.with? "shared-library"

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    if build.with? "shared-library"
      system ENV.cc, "test.c", "-o", "test",
             "-I#{include}", "-L#{lib}", "-lglfw"
    else
      system ENV.cc, "test.c", "-o", "test",
             "-I#{include}", "-L#{lib}", "-lglfw3",
             "-framework", "IOKit",
             "-framework", "CoreVideo",
             "-framework", "AppKit"
    end
    system "./test"
  end
end

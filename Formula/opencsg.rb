class Opencsg < Formula
  desc "The CSG rendering library"
  homepage "http://www.opencsg.org"
  url "http://www.opencsg.org/OpenCSG-1.4.1.tar.gz"
  sha256 "48182c8233e6f89cd6752679bde44ef6cc9eda4c06f4db845ec7de2cae2bb07a"

  bottle do
    cellar :any
    sha256 "577e6777db3c9ee1010577e9dd29f7d86cff106273ef650bf58b08b20020a751" => :el_capitan
    sha256 "d6e5913457b310b32a3dd9673a248793fd53bc6d2863f55b3d3334be7665c544" => :yosemite
    sha256 "26098d8c2d4e89f2a0389c470f8b094a805e97c959defa3381ab0cd8c8d8ec9e" => :mavericks
  end

  depends_on "qt5" => :build
  depends_on "glew"

  def install
    system "qmake", "-r", "INSTALLDIR=#{prefix}",
      "INCLUDEPATH+=#{Formula["glew"].opt_include}",
      "LIBS+=-L#{Formula["glew"].opt_lib} -lGLEW"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <opencsg.h>
      class Test : public OpenCSG::Primitive {
        public:
        Test() : OpenCSG::Primitive(OpenCSG::Intersection, 0) {}
        void render() {}
      };
      int main(int argc, char** argv) {
        Test test;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lopencsg",
           "-framework", "OpenGL"
    system "./test"
  end
end

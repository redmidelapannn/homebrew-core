class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.1.0/glew-2.1.0.tgz"
  sha256 "04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b48309b0b586272e47fb0ccac6d69d1c1c978a89272816d4642c71f0ef2fabe3" => :high_sierra
    sha256 "3fab9663d4dc228a1393290911032f593ae7bff6e6bf0aed83815cadfdec848e" => :sierra
    sha256 "46e0633114c425c9b321c4441e83d8e8e556537d2356b3ff597c91cb52db52fc" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    cd "build" do
      system "cmake", "./cmake", *std_cmake_args
      system "make"
      system "make", "install"
    end
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <GL/glew.h>
      #include <GLUT/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-o", "test", "-L#{lib}", "-lGLEW",
           "-framework", "GLUT"
    system "./test"
  end
end

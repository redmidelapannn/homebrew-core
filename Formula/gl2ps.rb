class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "https://www.geuz.org/gl2ps/"
  url "https://geuz.org/gl2ps/src/gl2ps-1.4.0.tgz"
  sha256 "03cb5e6dfcd87183f3b9ba3b22f04cd155096af81e52988cc37d8d8efe6cf1e2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c94a6d41e1b5a09a83689a3ee7773ad9239477ee6d1daf4f339fa487ed88213b" => :high_sierra
    sha256 "ee152f6382f71562e270b002a754ca3fde0bb48892ff60b67830dca096255c5f" => :sierra
    sha256 "f6ab7a900e19f12e43307f1bff583cda78f8a49c3e799c7687fd4c57e6c8e0af" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Prevent linking against X11's libglut.dylib when it's present
    # Reported to upstream's mailing list gl2ps@geuz.org (1st April 2016)
    # https://www.geuz.org/pipermail/gl2ps/2016/000433.html
    # Reported to cmake's bug tracker, as well (1st April 2016)
    # https://public.kitware.com/Bug/view.php?id=16045
    system "cmake", ".", "-DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <GLUT/glut.h>
      #include <gl2ps.h>

      int main(int argc, char *argv[])
      {
        glutInit(&argc, argv);
        glutInitDisplayMode(GLUT_DEPTH);
        glutInitWindowSize(400, 400);
        glutInitWindowPosition(100, 100);
        glutCreateWindow(argv[0]);
        GLint viewport[4];
        glGetIntegerv(GL_VIEWPORT, viewport);
        FILE *fp = fopen("test.eps", "wb");
        GLint buffsize = 0, state = GL2PS_OVERFLOW;
        while( state == GL2PS_OVERFLOW ){
          buffsize += 1024*1024;
          gl2psBeginPage ( "Test", "Homebrew", viewport,
                           GL2PS_EPS, GL2PS_BSP_SORT, GL2PS_SILENT |
                           GL2PS_SIMPLE_LINE_OFFSET | GL2PS_NO_BLENDING |
                           GL2PS_OCCLUSION_CULL | GL2PS_BEST_ROOT,
                           GL_RGBA, 0, NULL, 0, 0, 0, buffsize,
                           fp, "test.eps" );
          gl2psText("Homebrew Test", "Courier", 12);
          state = gl2psEndPage();
        }
        fclose(fp);
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lgl2ps", "-framework", "OpenGL", "-framework", "GLUT", "-framework", "Cocoa", "test.c", "-o", "test"
    system "./test"
    assert File.exist?("test.eps") && File.size("test.eps") > 0
  end
end

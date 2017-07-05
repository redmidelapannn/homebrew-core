class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "http://www.geuz.org/gl2ps/"
  url "http://geuz.org/gl2ps/src/gl2ps-1.3.9.tgz"
  sha256 "8a680bff120df8bcd78afac276cdc38041fed617f2721bade01213362bcc3640"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "374bceadad0375bf0c6eda359b2a055ef0042630f285757df938e5d0bb96c911" => :sierra
    sha256 "07122d11f05394efdfed990a6cec63d5885cac1735d2f83ada1a51279bb181bd" => :el_capitan
    sha256 "2dad709272fdaacb192032ad53b7666f436e6277e2a2257c645a6a6a32fe07d3" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Prevent linking against X11's libglut.dylib when it's present
    # Reported to upstream's mailing list gl2ps@geuz.org (1st April 2016)
    # http://www.geuz.org/pipermail/gl2ps/2016/000433.html
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

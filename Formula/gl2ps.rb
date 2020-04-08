class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "https://www.geuz.org/gl2ps/"
  url "https://geuz.org/gl2ps/src/gl2ps-1.4.1.tgz"
  sha256 "7362034b3d00ceef5601ff2d3dadb232c6678924e2594f32d73dfc9b202d5d3b"

  bottle do
    cellar :any
    sha256 "2396d73d237e12550305cf2367a3f5107a942459c713419ab8ac21c25414e536" => :catalina
    sha256 "9eaec2a32de5e3111b02599d6f2e5ed9e8e8fc6720ccc5bc35ee4c348cbc2162" => :mojave
    sha256 "c1c34d45f8d2f4aa6db11e1745289889e6b5513249b14a12f456b6878364bc29" => :high_sierra
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
    (testpath/"test.c").write <<~EOS
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
    system ENV.cc, "-L#{lib}", "-lgl2ps", "-framework", "OpenGL", "-framework", "GLUT",
                   "-framework", "Cocoa", "test.c", "-o", "test"
    system "./test"
    assert_predicate testpath/"test.eps", :exist?
    assert_predicate File.size("test.eps"), :positive?
  end
end

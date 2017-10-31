class Ftgl < Formula
  desc "Freetype / OpenGL bridge"
  homepage "https://sourceforge.net/projects/ftgl/"
  url "https://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz"
  sha256 "5458d62122454869572d39f8aa85745fc05d5518001bcefa63bd6cbb8d26565b"
  revision 1

  bottle do
    cellar :any
    sha256 "3dfc865989da0e9a0e0f1c1537da2f89230a0ad56d41ac6797b50da2f1bd58e4" => :high_sierra
    sha256 "9990c3398c460a3918b58a2a39cb8cc6f7133ce8edf2b852b005750fbd62809b" => :sierra
    sha256 "80cab29db26311323d68f97b96abed754b4982f32dd1da252fdf0bc69a374132" => :el_capitan
  end

  option "with-freeglut", "Builud with freeglut instead of GLUT.frameworks"

  depends_on "freetype"
  depends_on "freeglut" => :optional

  def install
    # If doxygen is installed, the docs may still fail to build.
    # So we disable building docs.
    inreplace "configure", "set dummy doxygen;", "set dummy no_doxygen;"

    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--disable-freetypetest"]

    if build.with?("freeglut")
      args << "--with-glut-inc=#{Formula["freeglut"].opt_include}" << "--with-glut-lib=#{Formula["freeglut"].opt_lib}"
    else
      args << "--with-glut-lib=-frameworks GLUT"
    end

    system "./configure", *args
    inreplace "demo/Makefile", "$(FT2_LIBS) $(GLUT_LIBS)", "$(FT2_LIBS) $(GL_LIBS) $(GLUT_LIBS)"
    system "make", "install"
  end
end

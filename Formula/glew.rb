class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  head "https://github.com/nigels-com/glew.git"

  stable do
    url "https://downloads.sourceforge.net/project/glew/glew/2.0.0/glew-2.0.0.tgz"
    sha256 "c572c30a4e64689c342ba1624130ac98936d7af90c3103f9ce12b8a0c5736764"

    patch do
      url "https://github.com/nigels-com/glew/commit/925722f91060a0a19acbf1a209cd7b96ed390c19.patch?full_index=1"
      sha256 "d20be5c8dde10eef46f8e8bb46818bd26e49ff9d2d657b7a4a7a478684a8e548"
    end

    patch do
      url "https://github.com/nigels-com/glew/commit/e7bf0f70b3b9528764e605794aa868db09ad47f4.patch?full_index=1"
      sha256 "2265dabd566701b991290a0948966ff88ab507452bf67367fb30f3d88c34fe7f"
    end

    patch do
      url "https://github.com/nigels-com/glew/commit/298528cd87019fe642a7ce9dfa772b62d7bf6aeb.patch?full_index=1"
      sha256 "d8c75c35f1c7dd0b13991c46e90f1181777696eea6918fc261668cd02bd27727"
    end
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "3b76f2c3f82a518f6ae9b6646f9765f72c6ae61c41d91583638197de29e5bd2a" => :sierra
    sha256 "0fcc3509423b0f0777a7fe31fee029e561933f93cd18ff2e3d0a79e832b280f6" => :el_capitan
    sha256 "c405a06e6d24e5f83a6ad27af0a82280ef0757e4984d8df4f9ea9a35f1e63d86" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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

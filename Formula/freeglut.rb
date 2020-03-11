class Freeglut < Formula
  desc "Open-source alternative to the OpenGL Utility Toolkit (GLUT) library"
  homepage "https://freeglut.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/freeglut/freeglut/3.2.1/freeglut-3.2.1.tar.gz"
  sha256 "d4000e02102acaf259998c870e25214739d1f16f67f99cb35e4f46841399da68"

  bottle do
    cellar :any
    rebuild 1
    sha256 "525990d82a25658bdd25c9c00e17be7df014ef49bf2a56037aefbf98a4fe0ea7" => :catalina
    sha256 "eb85ee39f49e997121b67b2da2a00dbf2997f9b0b482a92a956e30c180cd7dee" => :mojave
    sha256 "d50975d920c137c59fa27ea1478e164562abe93c0903bda70e5d7ba0a4a29d66" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :x11

  patch :DATA

  def install
    inreplace "src/x11/fg_main_x11.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH" if MacOS.version < :sierra
    system "cmake", *std_cmake_args, "-DFREEGLUT_BUILD_DEMOS=OFF", "."
    system "make", "all"
    system "make", "install"
  end
end

__END__

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 28f8651..d1f6a86 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -258,6 +258,16 @@
 IF(FREEGLUT_GLES)
     LIST(APPEND PUBLIC_DEFINITIONS -DFREEGLUT_GLES)
     LIST(APPEND LIBS GLESv2 GLESv1_CM EGL)
+ELSEIF(APPLE)
+  # on OSX FindOpenGL uses framework version of OpenGL, but we need X11 version
+  FIND_PATH(GLX_INCLUDE_DIR GL/glx.h
+            PATHS /opt/X11/include /usr/X11/include /usr/X11R6/include)
+  FIND_LIBRARY(OPENGL_gl_LIBRARY GL
+               PATHS /opt/X11/lib /usr/X11/lib /usr/X11R6/lib)
+  FIND_LIBRARY(OPENGL_glu_LIBRARY GLU
+               PATHS /opt/X11/lib /usr/X11/lib /usr/X11R6/lib)
+  LIST(APPEND LIBS ${OPENGL_gl_LIBRARY})
+  INCLUDE_DIRECTORIES(${GLX_INCLUDE_DIR})
 ELSE()
   FIND_PACKAGE(OpenGL REQUIRED)
   LIST(APPEND LIBS ${OPENGL_gl_LIBRARY})

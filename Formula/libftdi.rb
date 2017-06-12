class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.3.tar.bz2"
  sha256 "9a8c95c94bfbcf36584a0a58a6e2003d9b133213d9202b76aec76302ffaa81f4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4f8e8ac288749ddca9e4abf2d44bf49b5c48c1ca3751320a0e84af128f07e97d" => :sierra
    sha256 "fecf5de3d41e722fe4d762dc4da3ca46146a5a39737d79c789e3945a5de44632" => :el_capitan
    sha256 "2785080e1c76a7881db10358f093c97e18fbb5ecc06856f0c0b8f1bb1743f65e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "libusb"
  depends_on "boost" => :optional
  depends_on "confuse" => :optional

  # Fix LINK_PYTHON_LIBRARY=OFF on macOS
  # https://www.mail-archive.com/libftdi@developer.intra2net.com/msg03013.html
  patch :DATA

  option "universal", "Build universal binary (32-bit & 64-bit)"

  def install
    ENV.universal_binary if build.universal?

    extra_cmake_args = []
    extra_cmake_args << "-DBUILD_TESTS=OFF" if build.universal?

    mkdir "libftdi-build" do
      system "cmake", "..", "-DLINK_PYTHON_LIBRARY=OFF", *extra_cmake_args, *std_cmake_args
      system "make", "install"
      (libexec/"bin").install "examples/find_all"
    end
  end

  test do
    system libexec/"bin/find_all"
    system "python", pkgshare/"examples/simple.py"
  end
end
__END__
diff --git a/python/CMakeLists.txt b/python/CMakeLists.txt
index 8b52745..df0529a 100644
--- a/python/CMakeLists.txt
+++ b/python/CMakeLists.txt
@@ -12,8 +12,8 @@ if ( PYTHON_BINDINGS )
       set ( SWIG_FOUND TRUE )
     endif ()
   endif ()
-  find_package ( PythonLibs )
   find_package ( PythonInterp )
+  find_package ( PythonLibs )
 endif ()

 if ( SWIG_FOUND AND PYTHONLIBS_FOUND AND PYTHONINTERP_FOUND )
@@ -30,6 +30,8 @@ if ( SWIG_FOUND AND PYTHONLIBS_FOUND AND PYTHONINTERP_FOUND )

   if ( LINK_PYTHON_LIBRARY )
     swig_link_libraries ( ftdi1 ${PYTHON_LIBRARIES} )
+  elseif( APPLE )
+    set_target_properties ( ${SWIG_MODULE_ftdi1_REAL_NAME} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup" )
   endif ()

   set_target_properties ( ${SWIG_MODULE_ftdi1_REAL_NAME} PROPERTIES NO_SONAME ON )

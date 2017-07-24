class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.12.0%20Source/plplot-5.12.0.tar.gz"
  sha256 "8dc5da5ef80e4e19993d4c3ef2a84a24cc0e44a5dade83201fca7160a6d352ce"

  bottle do
    rebuild 1
    sha256 "b5dc39a08c7b37728acb6f777a5f26f9babe300d470d9d3720220d63308457c7" => :sierra
    sha256 "87a06bf1dd475900bd4a446ce3c729377055bd623eca62d0052a35d6444a3287" => :el_capitan
    sha256 "aa387bcff1c6ea8751b52d17fccaca466f952dadba49411e45a928a25adedf4e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "freetype"
  depends_on "libtool" => :run
  depends_on :x11 => :optional
  depends_on :fortran => :optional
  depends_on :java => :optional

  # Patch reported upstream. Fixes 5.12 cmake issue in cmake/modules/pkg-config.cmake that gets
  # triggered when passing `--with-fortran`
  patch :DATA

  def install
    args = std_cmake_args
    args << "-DENABLE_java=OFF" if build.without? "java"
    args << "-DPLD_xwin=OFF" if build.without? "x11"
    args << "-DENABLE_f95=OFF" if build.without? "fortran"
    args += %w[
      -DENABLE_ada=OFF
      -DENABLE_d=OFF
      -DENABLE_qt=OFF
      -DENABLE_lua=OFF
      -DENABLE_tk=OFF
      -DENABLE_python=OFF
      -DENABLE_tcl=OFF
      -DPLD_xcairo=OFF
      -DPLD_wxwidgets=OFF
      -DENABLE_wxwidgets=OFF
    ]

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <plplot.h>

      int main(int argc, char *argv[]) {
        plparseopts( &argc, argv, PL_PARSE_FULL );
        plsdev( "extcairo" );
        plinit();
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/plplot
      -L#{lib}
      -lcsirocsa
      -lltdl
      -lm
      -lplplot
      -lqsastime
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git i/cmake/modules/pkg-config.cmake w/cmake/modules/pkg-config.cmake
index 2b46dbe..7ecc789 100644
--- i/cmake/modules/pkg-config.cmake
+++ w/cmake/modules/pkg-config.cmake
@@ -230,7 +230,7 @@ function(pkg_config_link_flags link_flags_out link_flags_in)
     "/System/Library/Frameworks/([^ ]*)\\.framework"
     "-framework \\1"
     link_flags
-    ${link_flags}
+    "${link_flags}"
     )
     #message("(frameworks) link_flags = ${link_flags}")
   endif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")

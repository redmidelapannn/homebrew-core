class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.12.0%20Source/plplot-5.12.0.tar.gz"
  sha256 "8dc5da5ef80e4e19993d4c3ef2a84a24cc0e44a5dade83201fca7160a6d352ce"
  revision 1

  bottle do
    sha256 "b70b133ba1b6689873c9f44904553414e80ad2d20ebbcf5c7c74fc6d6b5280c5" => :sierra
    sha256 "b82e7dff72bce63dd2d119fbfc61b1f6a96c25e4a26384fe6ee2dded969c28aa" => :el_capitan
    sha256 "43affed0181a1af0db5d3d0f0f17762f4aa7752b7dabfd0687752849f5dc5d34" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "pango"
  depends_on "freetype"
  depends_on "libtool" => :run
  depends_on :x11
  depends_on :fortran => :optional
  depends_on :java => :optional

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

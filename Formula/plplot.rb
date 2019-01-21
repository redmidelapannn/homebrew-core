class Plplot < Formula
  desc "Cross-platform software package for creating scientific plots"
  homepage "https://plplot.sourceforge.io"
  url "https://downloads.sourceforge.net/project/plplot/plplot/5.14.0%20Source/plplot-5.14.0.tar.gz"
  sha256 "331009037c9cad9fcefacd7dbe9c7cfae25e766f5590f9efd739a294c649df97"
  revision 1

  bottle do
    rebuild 1
    sha256 "f78bc704cc6f3a31e677c3d40c43653c0d31dc72661dcb9165857129cb4d1328" => :mojave
    sha256 "41cc89563d9338bc51184b1de39a1eb35ab6e4e93f95495c98d19d614fd9533c" => :high_sierra
    sha256 "c08a86dd1b39931da4f60e224843f5f6bcd19386c169923a0af682705717429b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gcc" # for gfortran
  depends_on "pango"

  def install
    args = std_cmake_args + %w[
      -DPL_HAVE_QHULL=OFF
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
      -DENABLE_DYNDRIVERS=OFF
      -DENABLE_java=OFF
      -DPLD_xwin=OFF
    ]

    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # fix rpaths
    cd (lib.to_s) do
      Dir["*.dylib"].select { |f| File.ftype(f) == "file" }.each do |f|
        MachO::Tools.dylibs(f).select { |d| d.start_with?("@rpath") }.each do |d|
          d_new = d.sub("@rpath", opt_lib.to_s)
          MachO::Tools.change_install_name(f, d, d_new)
        end
      end
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <plplot.h>
      int main(int argc, char *argv[]) {
        plparseopts(&argc, argv, PL_PARSE_FULL);
        plsdev("extcairo");
        plinit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/plplot", "-L#{lib}",
                   "-lcsirocsa", "-lm", "-lplplot", "-lqsastime"
    system "./test"
  end
end

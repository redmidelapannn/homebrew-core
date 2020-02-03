class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.3.2.tar.gz"
  sha256 "c85de13b35dec40c920ff8a848a91c86af6f7c7ee77ed3c750f414bbbbb53924"
  revision 1

  bottle do
    cellar :any
    sha256 "d79e3521878acd73489c75d7a4e73576fdf81ad15b0a3d45549affc3468893ce" => :catalina
    sha256 "4f43997c44c4798e8d5f94fa8b045baeec261a80cd21a0ed65731b26dffce6d3" => :mojave
    sha256 "3c425d41950824eb9a0b1ea0e687f771fa5aa58b25be07b2ea4f63639517e756" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"
  depends_on "raptor"

  def install
    # upstream issue: https://github.com/SynBioDex/libSBOL/issues/215
    inreplace "source/CMakeLists.txt", "measure.h", "measurement.h"

    system "cmake", ".", "-DCMAKE_CXX_FLAGS=-I/System/Library/Frameworks/Python.framework/Headers",
                         "-DSBOL_BUILD_SHARED=TRUE",
                         "-DSBOL_BUILD_STATIC=FALSE",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "sbol/sbol.h"

      using namespace sbol;

      int main() {
        Document& doc = *new Document();
        doc.write("test.xml");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11",
                    "-I/System/Library/Frameworks/Python.framework/Headers",
                    "-I#{Formula["raptor"].opt_include}/raptor2",
                    "-I#{include}", "-L#{lib}",
                    "-L#{Formula["jsoncpp"].opt_lib}",
                    "-L#{Formula["raptor"].opt_lib}",
                    "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol"
    system "./test"
  end
end

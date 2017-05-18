class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "http://www.antlr.org"
  url "http://www.antlr.org/download/antlr4-cpp-runtime-4.7-source.zip"
  sha256 "3aa4bac23c60df14a687839b5e6aa7e94054112d3d3c5c8b1cffe270a4aeeaf7"

  bottle do
    cellar :any
    sha256 "c8e224adb8feea25510a0df4b5dd814b72f995b8134fd461ef00198bbfc78575" => :sierra
    sha256 "7c16c11a205a518bc776fc88bd1be54fe8d72a6298c25aabaf9530929d9568f0" => :el_capitan
    sha256 "e5bf7b9aa2b3c62bfaf56bae402ebea7d7d9d66108b3c17a249ef1325b360845" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "antlr" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
        #include <antlr4-runtime.h>
        int main(int argc, const char* argv[]) {
            try {
                throw antlr4::ParseCancellationException() ;
            } catch (antlr4::ParseCancellationException &exception) {
                /* ignore */
            }
            return 0 ;
        }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc", "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.7.1-source.zip"
  sha256 "23bebc0411052a260f43ae097aa1ab39869eb6b6aa558b046c367a4ea33d1ccc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d5c64d5888a7d44b05a702052b3f257c6e7f77d9f2460c4f2194688eb37c68e9" => :mojave
    sha256 "f119334508efedbb775228049374ec36d7901cbe4e41c26f0e8db5c8bc34c594" => :high_sierra
    sha256 "d689c4cc06f42c32c7a56cd24f4c368ef937cb68a4943ac373258b35c3d4ec6d" => :sierra
    sha256 "bf29d92526214dce49e5747c70f63e3f034efeaf8a064a3dda17dab82a1c0e24" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
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
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc",
                    "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

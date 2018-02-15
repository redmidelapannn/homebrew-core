class Antlr4CppRuntime < Formula
  desc "ANother Tool for Language Recognition C++ Runtime Library"
  homepage "https://www.antlr.org/"
  url "https://www.antlr.org/download/antlr4-cpp-runtime-4.7.1-source.zip"
  sha256 "23bebc0411052a260f43ae097aa1ab39869eb6b6aa558b046c367a4ea33d1ccc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6499547593a4e2d541739a9188216e0fb47d6a4ed5e7ed2e54f55cf94aac6432" => :high_sierra
    sha256 "e5e3efd6b6b69b45ca346684c961e7e027fd80ffd36f5f34d43052be1720c330" => :sierra
    sha256 "306024ab92c72a2cc43ff7986bb7ed506b20a6f9d54d2b7450d7c4be0529825f" => :el_capitan
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
    system ENV.cxx, "-std=c++11", "-I#{include}/antlr4-runtime", "test.cc", "-L#{lib}", "-lantlr4-runtime", "-o", "test"
    system "./test"
  end
end

class Curlpp < Formula
  desc "C++ wrapper for libcURL"
  homepage "https://www.curlpp.org/"
  url "https://github.com/jpbarrette/curlpp/archive/v0.8.1.tar.gz"
  sha256 "97e3819bdcffc3e4047b6ac57ca14e04af85380bd93afe314bee9dd5c7f46a0a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e5eec2f5a1a5c3868bab6e628d5b688bebbd343184bb3460c075dd2fa9746d89" => :high_sierra
    sha256 "fa415342b2911848bea2c2e97da36c7f93105e3754e3e164f009aeb8b6fd2293" => :sierra
    sha256 "7bd1805c56ce47fb07e895c3ebbf67d46103f0cddb1e8cbb31b8aa4729869fa1" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <curlpp/cURLpp.hpp>
      #include <curlpp/Easy.hpp>
      #include <curlpp/Options.hpp>
      #include <curlpp/Exception.hpp>

      int main() {
        try {
          curlpp::Cleanup myCleanup;
          curlpp::Easy myHandle;
          myHandle.setOpt(new curlpp::options::Url("https://google.com"));
          myHandle.perform();
        } catch (curlpp::RuntimeError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        } catch (curlpp::LogicError & e) {
          std::cout << e.what() << std::endl;
          return -1;
        }

        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lcurlpp", "-lcurl"
    system "./test"
  end
end

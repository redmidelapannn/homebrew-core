class Hayai < Formula
  desc "C++ benchmarking framework inspired by the googletest framework"
  homepage "http://nickbruun.dk/2012/02/07/easy-cpp-benchmarking"
  url "https://github.com/nickbruun/hayai/archive/v1.0.1.tar.gz"
  sha256 "40798cb3a7b5fcd4e0be65f9358dad4efeef7c4ebe8319327d99a2b8e5dcea4c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d9535e3bb36561dbd063e2d1cc58ee94ecc6d1b91e15f7903547089a057e17fa" => :sierra
    sha256 "d36d84bbdddda46064cfcbecf1035de3f9b247507fdb4d3e1c34ff90decafee4" => :el_capitan
    sha256 "b7b20b1a1f2c38f21683303af4ec45a4ca44540ffd7238c02627e5485b465690" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <hayai/hayai.hpp>
      #include <iostream>
      int main() {
        hayai::Benchmarker::RunAllTests();
        return 0;
      }

      BENCHMARK(HomebrewTest, TestBenchmark, 1, 1)
      {
        std::cout << "Hayai works!" << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lhayai_main", "-o", "test"
    system "./test"
  end
end

class Hayai < Formula
  desc "C++ benchmarking framework inspired by the googletest framework"
  homepage "https://bruun.co/2012/02/07/easy-cpp-benchmarking"
  url "https://github.com/nickbruun/hayai/archive/v1.0.2.tar.gz"
  sha256 "e30e69b107361c132c831a2c8b2040ea51225bb9ed50675b51099435b8cd6594"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1e99eeb95a210103b39769282467520b4ee85f65087b90f69f8c3ce823fd9442" => :mojave
    sha256 "2d0d3b5acb0ec2b783ed6edf77cf2c2148f57e967e4b8047e45122a71d26edd5" => :high_sierra
    sha256 "0546f6117d44731d1bac5a6ae5802d44bd6a249ef13a96c126e02c60e8b5bf6c" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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

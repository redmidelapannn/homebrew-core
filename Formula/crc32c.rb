class Crc32c < Formula
  desc "Implements CRC32C, supports CPU-specific acceleration instructions"
  homepage "https://github.com/google/crc32c"
  url "https://github.com/google/crc32c/archive/1.0.5.tar.gz"
  sha256 "c2c0dcc8d155a6a56cc8d56bc1413e076aa32c35784f4d457831e8ccebd9260b"
  head "https://github.com/google/crc32c.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c4d4578c1772ae36e450d993246fa0ea7d6a59d543b77061ee46d7b2e4af8625" => :high_sierra
    sha256 "0754a96f0b99417ff8f5b71b7277905c9ab80dcec42853cb8e64a2594ab24c49" => :sierra
    sha256 "a1f03cd7b0be4f63903e1426cee1efbb835519acb5b46ed011f506c171c7876f" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DCRC32C_BUILD_TESTS=0", "-DCRC32C_BUILD_BENCHMARKS=0", "-DCRC32C_USE_GLOG=0", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", "-DCRC32C_BUILD_TESTS=0", "-DCRC32C_BUILD_BENCHMARKS=0", "-DCRC32C_USE_GLOG=0", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <crc32c/crc32c.h>
      #include <cstdint>
      #include <string>

      int main()
      {
        std::uint32_t expected = 0xc99465aa;
        std::uint32_t result = crc32c::Crc32c(std::string("hello world"));
        assert(result == expected);
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lcrc32c", "-o", "test"
    system "./test"
  end
end

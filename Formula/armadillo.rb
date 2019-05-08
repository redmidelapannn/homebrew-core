class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.400.3.tar.xz"
  sha256 "f4c9ce4ee719e935f0046dcafb3fe40ffd8e1b80cc16a4d2c03332ea37d857a6"

  bottle do
    cellar :any
    sha256 "bccf7183dfdea6382ac08d24e08e2602abaa54132f298f2ba371c2f039e113b5" => :mojave
    sha256 "96ec547d62f8472fbf2108397b4fa724495d4533b8b6694a9ce48b4e60b9f1fe" => :high_sierra
    sha256 "f14e0a97de930154bef3cf2c0b2fb2ad84acec0c8d7d96af3e03a940cb1b25df" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "superlu"

  def install
    system "cmake", ".", "-DDETECT_HDF5=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal Utils.popen_read("./test").to_i, version.to_s.to_i
  end
end

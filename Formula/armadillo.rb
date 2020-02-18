class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.850.1.tar.xz"
  sha256 "d4c389b9597a5731500ad7a2656c11a6031757aaaadbcafdea5cc8ac0fd2c01f"
  revision 1

  bottle do
    cellar :any
    sha256 "1ce8d9e48450c00ba7613d2da40797a73478d69221d874bbe3254a31b6feb3cd" => :catalina
    sha256 "489afc6767c0c4d0b026f66bb70a8e00d2cd85d73658f0dd1b4551d75c5ec186" => :mojave
    sha256 "5556154d6286f89a41977cf2db5c2f8b68e1009562a21a272f8f03a3fbd99030" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

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

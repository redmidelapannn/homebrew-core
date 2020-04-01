class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.860.1.tar.xz"
  sha256 "1603888ab73b7f0588df1a37a464436eb0ff6b1372a9962ee1424b4329f165a9"

  bottle do
    cellar :any
    sha256 "be317be8073ac3afc2c7427e4657fde72b6eeb0949115fb80e7205b07716770e" => :catalina
    sha256 "f718be7c7268077ebe72b52f1030e4b08ab349eda5d9457bc33b0388cfdd254d" => :mojave
    sha256 "a2c5616cee1ce4bc912ac6aa49e2500ce6ab27ed7a7931017ac4e1dd5bb8453a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

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

class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      :tag      => "v1.0.0",
      :revision => "d90e7b31170b86f97eafb6b9b64027abb6881a3e"

  bottle do
    cellar :any
    sha256 "d760bf2f1a3fca17a874f01d39f385edce0bdb0422bb8b870cdc22db5d0f0e30" => :catalina
    sha256 "12d81b7185b1d6182cf4546250e43bc96a571864f821442b702f6d63c5fcd645" => :mojave
    sha256 "027aebd4b965b8fdd8051a11fde14d79f8eef7a39827cfdfdcf6c62b7507df77" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      libomp = Formula["libomp"]
      args = std_cmake_args
      args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"

      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end

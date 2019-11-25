class Thundersvm < Formula
  desc "Fast SVM Library on GPUs and CPUs"
  homepage "https://github.com/Xtra-Computing/thundersvm"
  url "https://github.com/Xtra-Computing/thundersvm/archive/0.3.3.tar.gz"
  sha256 "0328511caa762ebbf5f7174c2a3cf7a05393b93fff51a6819bcdd5b25e5c54ae"

  bottle do
    cellar :any
    sha256 "647f4d5aa0275b39b33edfb1653d8437ba5411ecd5543fae9b4d79c9f3561b9a" => :catalina
    sha256 "52ec9d6d2e6629cd1fc9b913ae565016e1882fa91fc090f7be8fdb3236fd5136" => :mojave
    sha256 "321b3db648d0b2e80cefddb5deebf8ac560e6e6cf7d9ef13f15999a680cec7f8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "libomp"

  def install
    inreplace "CMakeLists.txt", "${PROJECT_SOURCE_DIR}/eigen", "#{Formula["eigen"].opt_include}/eigen3"

    (buildpath/"src/thundersvm/CMakeLists.txt").append_lines <<~EOS
      target_link_libraries(${PROJECT_LIB_NAME} OpenMP::OpenMP_CXX)
    EOS

    mkdir "build" do
      args = std_cmake_args
      args << "-DUSE_CUDA=OFF"
      args << "-DUSE_EIGEN=ON"

      # keep same performance as when built manually
      args << "-DCMAKE_CXX_FLAGS_RELEASE=-O3"

      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"

      system "cmake", "..", *args
      system "make"

      bin.install "bin/thundersvm-predict"
      bin.install "bin/thundersvm-train"
      lib.install "lib/libthundersvm.dylib"
    end

    pkgshare.install "dataset"
  end

  test do
    system "#{bin}/thundersvm-train", "-c", "100", "-g", "0.5", "#{pkgshare}/dataset/test_dataset.txt", "model.txt"
    system "#{bin}/thundersvm-predict", "#{pkgshare}/dataset/test_dataset.txt", "model.txt", "out.txt"
  end
end

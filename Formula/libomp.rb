class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/openmp-9.0.1.src.tar.xz"
  sha256 "5c94060f846f965698574d9ce22975c0e9f04c9b14088c3af5f03870af75cace"

  bottle do
    cellar :any
    sha256 "9fd9fde692bb74837400788a60ceb3822fee3560ee4f013f9163710abd3117c1" => :catalina
    sha256 "fb4cd79b18ce160393ab87bf8c7bea5c1e52d0bb2b26fd70058d5239010e6635" => :mojave
    sha256 "22213fdebbde7cd5b793203b18280d35b70add744b496751821dd060e5ab1326" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite

  def install
    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    system "cmake", ".", *std_cmake_args, "-DLIBOMP_INSTALL_ALIASES=OFF"
    system "make", "install"
    system "cmake", ".", "-DLIBOMP_ENABLE_SHARED=OFF", *std_cmake_args,
                         "-DLIBOMP_INSTALL_ALIASES=OFF"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <omp.h>
      #include <array>
      int main (int argc, char** argv) {
        std::array<size_t,2> arr = {0,0};
        #pragma omp parallel num_threads(2)
        {
            size_t tid = omp_get_thread_num();
            arr.at(tid) = tid + 1;
        }
        if(arr.at(0) == 1 && arr.at(1) == 2)
            return 0;
        else
            return 1;
      }
    EOS
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp",
                    "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end

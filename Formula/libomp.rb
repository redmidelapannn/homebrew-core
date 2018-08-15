class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "http://releases.llvm.org/6.0.1/openmp-6.0.1.src.tar.xz"
  sha256 "66afca2b308351b180136cf899a3b22865af1a775efaf74dc8a10c96d4721c5a"

  bottle do
    cellar :any
    sha256 "052ae84367a49c68b5966ec1751fb08cf5319fcf3a68cacf6be91699599b2a9b" => :high_sierra
    sha256 "319ad3a51741c7273b10f0fa49097e48fd65e2662d670f136915fa12947bc39d" => :sierra
    sha256 "d68ff3e0470eb6c0c7aba1f211b55897c50c866f6915e69d2a51f821257dd56d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    system "cmake", ".", "-DLIBOMP_ENABLE_SHARED=OFF", *std_cmake_args
    system "make", "install"
  end

  def caveats; <<~EOS
    On Apple Clang, you need to add several options to use OpenMP's front end
    instead of the standard driver option. This usually looks like
      -Xpreprocessor -fopenmp -lomp

    You might need to make sure the lib and include directories are discoverable
    if #{HOMEBREW_PREFIX} is not searched:

      -L#{opt_lib} -I#{opt_include}

    For CMake, the following flags will cause the OpenMP::OpenMP_CXX target to
    be set up correctly:
      -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp -I#{opt_include}" -DOpenMP_CXX_LIB_NAMES="omp" -DOpenMP_omp_LIBRARY=#{opt_lib}/libomp.dylib
  EOS
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

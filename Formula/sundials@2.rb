class SundialsAT2 < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz"
  sha256 "d39fcac7175d701398e4eb209f7e92a5b30a78358d4a0c0fcc23db23c11ba104"

  bottle do
    cellar :any
    sha256 "fb468ee28731fbd662cfc626c088297c818f8a50c35dba7503a6bb0cee220531" => :high_sierra
    sha256 "6ac79eba75b2be2979bc676df239c2235996a6c1c9570e09013481abf0ee3bda" => :sierra
    sha256 "1761c1e53274136bc362ff3406a5f977ca5a72acbaaf0677d788ba5c26928ad3" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-openmp", "Enable OpenMP multithreading"
  deprecated_option "without-mpi" => "without-open-mpi"

  depends_on "cmake" => :build
  depends_on "python" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi" => :recommended
  depends_on "suite-sparse"
  depends_on "openblas"

  fails_with :clang if build.with? "openmp"

  def install
    blas = "-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=#{ENV["CC"]}
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
    ]
    args << "-DOPENMP_ENABLE=ON" if build.with? "openmp"
    args << "-DMPI_ENABLE=ON" if build.with? "open-mpi"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp Dir[prefix/"examples/nvector/serial/*"], testpath
    system ENV.cc, "-I#{include}", "test_nvector.c", "sundials_nvector.c",
                   "test_nvector_serial.c", "-L#{lib}", "-lsundials_nvecserial", "-lm"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./a.out 42 0")
  end
end

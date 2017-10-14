class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz"
  sha256 "d39fcac7175d701398e4eb209f7e92a5b30a78358d4a0c0fcc23db23c11ba104"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "8b58ca3ce4b7a3982fee1ee4a8ce95b9ed6910de769e7838c5b7334c0cc4ac61" => :high_sierra
    sha256 "6e98b8aa1161578cb7fbaabd958d3943efb879ccb5e0b9c5e18e668b1707f635" => :sierra
    sha256 "c151c64348355e49f0cc57e72c21ea246f1da8e5a34fed749bb6e249c10533eb" => :el_capitan
  end

  devel do
    url "https://computation.llnl.gov/projects/sundials/download/sundials-3.0.0-beta-2.tar.gz"
    sha256 "0e597707b4210dee9ab3583f072c2e5513b28cbbd8465296fc5c203074b225dd"
    version "3.0.0-beta-2"
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "cmake" => :build
  depends_on "suite-sparse"
  depends_on "veclibfort"
  depends_on :fortran
  depends_on :mpi => [:cc, :f77, :recommended]

  needs :openmp if build.with?("openmp")

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
    args << "-DMPI_ENABLE=ON" if build.with? "mpi"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp Dir[prefix/"examples/nvector/serial/*"], testpath
    system ENV.cc, "-I#{include}", "test_nvector.c", "sundials_nvector.c",
                   "test_nvector_serial.c", "-L#{lib}", "-lsundials_nvecserial"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./a.out 42 0")
  end
end

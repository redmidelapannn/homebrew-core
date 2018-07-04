class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.8.tar.gz"
  sha256 "6113262f6e92c5bd474f2875fa1b01054c4ad5040f6b0da7c03c98821d9ae303"

  bottle do
    rebuild 1
    sha256 "c249ebfff3839876eaa3b34ea11e441ca7d32cb18ce6bba1e60bdf57a1d54ca1" => :high_sierra
    sha256 "a08df2ee1fa275b2612f8e3835144fc058e090c554180b0d38d814983e3feab0" => :sierra
    sha256 "38bd0ffc4b39d1cc0a35b87f1b00d15fce223478c264c405f929c73ef66a3fd3" => :el_capitan
  end

  option "with-openmp", "Enable OpenMP parallel transforms"
  option "without-fortran", "Disable Fortran bindings"

  depends_on "cmake" => :build
  depends_on "gcc" if build.with?("fortran") || build.with?("openmp")
  fails_with :clang if build.with? "openmp"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTS=off"
    args << "-DENABLE_THREADS=on"

    simd_args = ["-DENABLE_SSE2=on"]
    simd_args << "-DENABLE_AVX=on" if ENV.compiler == :clang && Hardware::CPU.avx? && !build.bottle?
    simd_args << "-DENABLE_AVX2=on" if ENV.compiler == :clang && Hardware::CPU.avx2? && !build.bottle?

    args << "-DDISABLE_FORTRAN=on" if build.without? "fortran"
    args << "-DENABLE_OPENMP=on" if build.with? "openmp"

    ## long double precision
    ## no SIMD optimization available
    system "cmake", ".", "-DBUILD_SHARED_LIBS=on", "-DENABLE_FLOAT=off", "-DENABLE_LONG_DOUBLE=on", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=off", "-DENABLE_FLOAT=off", "-DENABLE_LONG_DOUBLE=on", *args
    system "make", "install"
    system "make", "clean"

    ## default(double) precision
    ## enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "cmake", ".", "-DBUILD_SHARED_LIBS=on", "-DENABLE_FLOAT=off", "-DENABLE_LONG_DOUBLE=off", *(args + simd_args)
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=off", "-DENABLE_FLOAT=off", "-DENABLE_LONG_DOUBLE=off", *(args + simd_args)
    system "make", "install"
    system "make", "clean"

    system "cmake", ".", "-DBUILD_SHARED_LIBS=on", "-DENABLE_FLOAT=on", "-DENABLE_LONG_DOUBLE=off", *(args + simd_args)
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=off", "-DENABLE_FLOAT=on", "-DENABLE_LONG_DOUBLE=off", *(args + simd_args)
    system "make", "install"
  end

  test do
    # Adapted from the sample usage provided in the documentation:
    # http://www.fftw.org/fftw3_doc/Complex-One_002dDimensional-DFTs.html
    (testpath/"fftw.c").write <<~EOS
      #include <fftw3.h>
      int main(int argc, char* *argv)
      {
          fftw_complex *in, *out;
          fftw_plan p;
          long N = 1;
          in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
          p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);
          fftw_execute(p); /* repeat as needed */
          fftw_destroy_plan(p);
          fftw_free(in); fftw_free(out);
          return 0;
      }
    EOS

    system ENV.cc, "-o", "fftw", "fftw.c", "-L#{lib}", "-lfftw3", *ENV.cflags.to_s.split
    system "./fftw"
  end
end

class Fftw < Formula
  desc "C routines to compute the Discrete Fourier Transform"
  homepage "http://www.fftw.org"
  url "http://fftw.org/fftw-3.3.8.tar.gz"
  sha256 "6113262f6e92c5bd474f2875fa1b01054c4ad5040f6b0da7c03c98821d9ae303"
  revision 2

  bottle do
    cellar :any
    sha256 "d61ba42fc4b83b3080f25d05de6a0a01599b7e73e2479857caba62e454f601ec" => :catalina
    sha256 "38ffa74aca0b5e75a352761379a21612ff1d93017a88b27c2fefd90e531ee16e" => :mojave
    sha256 "66a2d8b13f32178d0cb7eecfafd5b8d2d700fcd22373118b1b4a0d72b7dcb9b8" => :high_sierra
  end

  depends_on "gcc"
  depends_on "libomp"
  depends_on "open-mpi"

  def install
    system "gfortran -dumpspecs | sed 's/gomp/omp/g' > specs"
    inreplace "ltmain.sh", "|-fopenmp|-openmp|-mp|-xopenmp|-omp|-qsmp=*", ""

    args = [
      "--enable-shared",
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-threads",
      "--disable-dependency-tracking",
      "--enable-mpi",
      "--enable-openmp",
      "ax_cv_c_openmp=-Xpreprocessor -fopenmp -Xlinker -lomp",
      "FC=gfortran -specs=#{buildpath}/specs",
    ]

    # FFTW supports runtime detection of CPU capabilities, so it is safe to
    # use with --enable-avx and the code will still run on all CPUs
    simd_args = ["--enable-sse2", "--enable-avx"]

    # single precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", "--enable-single", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the double precision variant
    system "make", "clean"

    # double precision
    # enable-sse2, enable-avx and enable-avx2 work for both single and double precision
    system "./configure", *(args + simd_args)
    system "make", "install"

    # clean up so we can compile the long-double precision variant
    system "make", "clean"

    # long-double precision
    # no SIMD optimization available
    system "./configure", "--enable-long-double", *args
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

class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/libcerf"
  url "https://jugit.fz-juelich.de/mlz/libcerf/uploads/924b8d245ad3461107ec630734dfc781/libcerf-1.13.tgz"
  sha256 "011303e59ac63b280d3d8b10c66b07eb02140fcb75954d13ec26bf830e0ea2f9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4064be197500e6225958931788215d97ff3e16dfaed6a72063681faf588464fb" => :mojave
    sha256 "42e4c36d16e20557fdc791fac9708aad173cfae1858d6facd46119d7df88fa3f" => :high_sierra
    sha256 "37b36bd8c3fb2d00b1441f30d99dd2b212c35d10806a3d08073570f087c222af" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cerf.h>
      #include <complex.h>
      #include <math.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main (void) {
        double _Complex a = 1.0 - 0.4I;
        a = cerf(a);
        if (fabs(creal(a)-0.910867) > 1.e-6) abort();
        if (fabs(cimag(a)+0.156454) > 1.e-6) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end

class Openblas < Formula
  desc "Optimized BLAS library"
  homepage "https://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.3.7.tar.gz"
  sha256 "bde136122cef3dd6efe2de1c6f65c10955bbb0cc01a520c2342f5287c28f9379"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "be99e286393dc6e318105d911a80774c52bfb92fde57268cb3d22fb062a03946" => :catalina
    sha256 "f93c180e4828f439a79383d729272827413a6f22465565e4e9b1fbc37a139b8b" => :mojave
    sha256 "a4b9b902327398bdf5399fa72d5f5d21059f0d6dcdffd344f14cea33ad03a567" => :high_sierra
  end

  keg_only :provided_by_macos,
           "macOS provides BLAS and LAPACK in the Accelerate framework"

  depends_on "gcc" # for gfortran
  depends_on "libomp"

  patch :DATA

  def install
    ENV["DYNAMIC_ARCH"] = "1"
    ENV["USE_OPENMP"] = "1"
    ENV["NO_AVX512"] = "1"

    system "gfortran -dumpspecs | sed 's/gomp/omp/g' > specs"

    # Must call in two steps
    system "make", "CC=#{ENV.cc}", "FC=gfortran -specs=#{buildpath}/specs", "libs", "netlib", "shared"
    system "make", "PREFIX=#{prefix}", "install"

    lib.install_symlink "libopenblas.dylib" => "libblas.dylib"
    lib.install_symlink "libopenblas.dylib" => "liblapack.dylib"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "cblas.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenblas",
                   "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/Makefile.system b/Makefile.system
index 09a648e4..25c978b3 100644
--- a/Makefile.system
+++ b/Makefile.system
@@ -479,7 +479,7 @@ CCOMMON_OPT    += -fopenmp
 endif

 ifeq ($(C_COMPILER), CLANG)
-CCOMMON_OPT    += -fopenmp
+CCOMMON_OPT    += -Xpreprocessor -fopenmp -Xlinker -lomp
 endif

 ifeq ($(C_COMPILER), INTEL)
diff --git a/c_check b/c_check
index 271182c5..8012a10b 100644
--- a/c_check
+++ b/c_check
@@ -161,7 +161,7 @@ if ($compiler eq "OPEN64") {
 }

 if ($compiler eq "CLANG") {
-    $openmp = "-fopenmp";
+    $openmp = "-Xpreprocessor -fopenmp -Xlinker -lomp";
 }

 if ($compiler eq "GCC" || $compiler eq "LSB") {

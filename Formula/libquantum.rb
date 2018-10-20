class Libquantum < Formula
  desc "C library for the simulation of quantum mechanics"
  homepage "http://www.libquantum.de/"
  url "http://www.libquantum.de/files/libquantum-1.0.0.tar.gz"
  sha256 "b0f1a5ec9768457ac9835bd52c3017d279ac99cc0dffe6ce2adf8ac762997b2c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "589e1a2024e60baace2c99588197e3d938d2534df1d36fdfcf14055c60836b12" => :mojave
    sha256 "0a995f5328a9911ede2de5afb2600918ff260ab5858e5537dd098741273981f8" => :high_sierra
    sha256 "531fe5bb36f29471b9979b2ab52c3333598ac58f464c469811bdc071bb1a40da" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"qtest.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <time.h>
      #include <quantum.h>

      int main ()
      {
        quantum_reg reg;
        int result;
        srand(time(0));
        reg = quantum_new_qureg(0, 1);
        quantum_hadamard(0, &reg);
        result = quantum_bmeasure(0, &reg);
        printf("The Quantum RNG returned %i!\\n", result);
        return 0;
      }
    EOS
    system ENV.cc, "-O3", "-o", "qtest", "qtest.c", "-L#{lib}", "-lquantum"
    system "./qtest"
  end
end

class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "http://octopus-code.org/wiki/Libxc"
  url "http://www.tddft.org/programs/octopus/down.php?file=libxc/4.0.3/libxc-4.0.3.tar.gz"
  sha256 "85aec0799bb77c0eca13f11b7124601d4b2ba5961dd390a98a3163fc9f1dbae7"

  bottle do
    cellar :any
    sha256 "be3db9f0de25a72af6ee4f7c2f0db644eefa7b7ec19010b2fca28c57d3aac70c" => :high_sierra
    sha256 "6d4322861bf3fa2f70682aeec91f81a97b5dc7377c1b8d23642e70a4b6d1a82e" => :sierra
    sha256 "18c110f8627293c8f8ad1ff1053bea35063dea4881e417b9afb1a5c271839063" => :el_capitan
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf(\"%d.%d.%d\", major, minor, micro);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ctest"
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f90_types_m
        use xc_f90_lib_m
      end program lxctest
    EOS
    ENV.fortran
    system ENV.fc, "test.f90", "-L#{lib}", "-lxc", "-I#{include}", "-o", "ftest"
    system "./ftest"
  end
end

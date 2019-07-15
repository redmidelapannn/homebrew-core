class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/fitsio/"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.47.tar.gz"
  version "3.470"
  sha256 "418516f10ee1e0f1b520926eeca6b77ce639bed88804c7c545e74f26b3edf4ef"

  bottle do
    sha256 "5818a9f009b56d39d2cb68eadb820ae6234c17fa1775b523946fd8faee19be53" => :mojave
    sha256 "2834bae1ef032b84ee864406c5a3dec47bc1ac134e1c1122252e8bd08f961d65" => :high_sierra
    sha256 "398c2035838f8e6c3e1e81b686dda00cc902d0e37e3be2c2fd8f608b7327f0f7" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "fpack", "funpack"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    system ENV.cc, "testprog.c", "-o", "testprog", "-I#{include}",
                   "-L#{lib}", "-lcfitsio"
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end

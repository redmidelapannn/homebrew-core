class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.47.tar.gz"
  version "3.470"
  sha256 "418516f10ee1e0f1b520926eeca6b77ce639bed88804c7c545e74f26b3edf4ef"

  bottle do
    cellar :any
    sha256 "087d62b4967387a36a0115aaf21fd42c37cb57dfde1c135702d056b3d4157f75" => :catalina
    sha256 "f86025edc9ee983cd31c4f486d82d05f4a4bd78f2b1cf840ee7a093781bbb6be" => :mojave
    sha256 "ec39fb1ca14b637019529aa0cdfa6489c45aae3a1b3e4ab2a32bd3c3b9aada6b" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
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

class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3420.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3420.tar.gz"
  version "3.420"
  sha256 "6c10aa636118fa12d9a5e2e66f22c6436fb358da2af6dbf7e133c142e2ac16b8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "479098537f2d866133e7dd85bd4b9eb3d2ef4f8472f404d05cfe3abe2ef6d702" => :high_sierra
    sha256 "288a78110f365d9905ed2e91b75e82dd0341e149c40c24b63e5dbbac792edb8c" => :sierra
    sha256 "54303befcf5650094d721892accaaff31ad9ea1164ba81829f0903f8bab68359" => :el_capitan
  end

  option "with-reentrant", "Build with support for concurrency"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-reentrant" if build.with? "reentrant"
    system "./configure", *args
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

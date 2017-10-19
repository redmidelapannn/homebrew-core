class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3420.tar.gz"
  mirror "https://fossies.org/linux/misc/cfitsio3420.tar.gz"
  version "3.420"
  sha256 "6c10aa636118fa12d9a5e2e66f22c6436fb358da2af6dbf7e133c142e2ac16b8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6514ab5f67a80432da2306065d856d148b241f026152df1b6f99ff377f072e25" => :high_sierra
    sha256 "daf47cb03b82ff0b60a5eb78d76839488cdc877aaa5a206a360114692d6dc21f" => :sierra
    sha256 "b1697d65d5b16f4a9f3440e551b1dbfde8c1fdc4ef98ca99249b3e13bf8e0856" => :el_capitan
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

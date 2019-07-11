class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-3.47.tar.gz"
  version "3.470"
  sha256 "418516f10ee1e0f1b520926eeca6b77ce639bed88804c7c545e74f26b3edf4ef"

  bottle do
    sha256 "1b9107f1bea473b3661d6434bb6065cd33bab175bc56a4e5d0bf6e7382896643" => :mojave
    sha256 "cff65ff1977873738136223db376d5ad6e8f5f5c257f4a7c4e0718b9d94155f7" => :high_sierra
    sha256 "115b53dee145fb5118f33b2d2d53a2fc4281d0a52dcf089afbe01b787e78c228" => :sierra
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

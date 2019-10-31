class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-6.4.tar.bz2"
  sha256 "13c11ff70a7725563ec5fa52707a9965fce186a1766db193d08c9766ea107000"
  revision 1

  bottle do
    cellar :any
    sha256 "7c97080f91d7b17f0c3dd4a1409c572b1e14aca261ed5a063ff4e75d80c47d24" => :catalina
    sha256 "0e76ec4d14347ccc6bfbff2323c2ff1b722e29ac6ab9314a2e99f5dd9e4d9b26" => :mojave
    sha256 "9969ed76960e5e142a919ab54ae0db6e9a71e25092f4a80990bcc99f1a0a5266" => :high_sierra
  end

  depends_on "cfitsio"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cfitsiolib=#{Formula["cfitsio"].opt_lib}",
                          "--with-cfitsioinc=#{Formula["cfitsio"].opt_include}",
                          "--without-pgplot",
                          "--disable-fortran"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + " "*20 + "T / comment" + " "*40 + "END" + " "*2797
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end

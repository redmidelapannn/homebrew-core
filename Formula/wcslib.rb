class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-5.19.1.tar.bz2"
  sha256 "59b9f0e5a2c040773cc846c684d84c09b986c1393e97b378a41b92d9d3df0f98"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ae38846741c56137b88c1e5ce971c6fd79f3c32b599bc16cb4a0c7a4a441520e" => :mojave
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

    # Currently doesn't support parallel make.  Patch sent to author 2018/08/31.
    # Author (mcalabre@atnf.csiro.au) expects to integrate by end of 2018/09.
    # Patch: https://gist.github.com/dstndstn/0492f69eb27a11cdd622d01105643dd0
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    piped = "SIMPLE  =" + " "*20 + "T / comment" + " "*40 + "END" + " "*2797
    pipe_output("#{bin}/fitshdr", piped, 0)
  end
end

class Wcslib < Formula
  desc "Library and utilities for the FITS World Coordinate System"
  homepage "https://www.atnf.csiro.au/people/mcalabre/WCS/"
  url "https://www.atnf.csiro.au/pub/software/wcslib/wcslib-6.2.tar.bz2"
  sha256 "bb4dfe242959bc4e5540890e0475754ad4a027dba971903dc4d82df8d564d805"
  revision 1

  bottle do
    cellar :any
    sha256 "362313180ecf9bec238f620e3b23711721c838a61b34990d246e603da2f34b9c" => :mojave
    sha256 "26045f196348f4012259f418a6316224dc1bb0726c1c717bd36885da0f819115" => :high_sierra
    sha256 "f43693e8cac549e7eb923f1e169c01ac6470ea7837f553c993746aa812ae65f1" => :sierra
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

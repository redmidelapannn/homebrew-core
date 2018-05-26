class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "http://rpm5.org"
  url "http://rpm5.org/files/popt/popt-1.16.tar.gz"
  mirror "https://ftp.openbsd.org/pub/OpenBSD/distfiles/popt-1.16.tar.gz"
  sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"

  bottle do
    rebuild 2
    sha256 "fded21bc4faa50351f9699c426d8f351f90a352595232ebe5595cf65177f77fe" => :high_sierra
    sha256 "1bc9e168ede8da0740fb93877b2267fedc470b5a3871235e76bcd9077db23489" => :sierra
    sha256 "82b518afdf73b78664016547b0a276f5affd0808fca57938c1a286a7f9a3ac3a" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

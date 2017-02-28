class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "http://rpm5.org"
  url "http://rpm5.org/files/popt/popt-1.16.tar.gz"
  sha256 "e728ed296fe9f069a0e005003c3d6b2dde3d9cad453422a10d6558616d304cc8"

  bottle do
    rebuild 2
    sha256 "bf535a9b212cb5bd0bd9990332a99c4a85bfd8fe6c7309a365560156b28e7b40" => :sierra
    sha256 "0c7caf8bb3286d5fe41b1f4ed9546372edcb4a2c32066581c8b958fc882576a8" => :el_capitan
    sha256 "214e5b93ebd612c667f57d3945932a3609eae3d81a47574ff313687b8c495915" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

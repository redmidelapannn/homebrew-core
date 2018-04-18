class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.2.tar.gz"
  sha256 "1ae0ce1c38c728b5c98adcf490135b32ab646cf5c023653fb5394f43a34f808a"
  revision 1

  bottle do
    rebuild 1
    sha256 "850442ebe8da8a1e3cbe2aa78191bc3d68fcd8d0ff77f30a6d651bb55c2d2e32" => :high_sierra
    sha256 "81a43c78c5565366ddce597e6950ce40296a8e2b2d101722a7845636940dcc5e" => :sierra
    sha256 "707671e3df83a5551fe1b4e0d91dff15480ff64a5f9e4558993039f4278dc0e8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end

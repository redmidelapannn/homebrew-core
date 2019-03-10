class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.6.tar.gz"
  sha256 "5840192eb4a1a4e500f65eedfebacd4bc4b9192c696ea51d719732dc2c75530a"

  bottle do
    sha256 "7c30e9872d09d1b11a73d0f87d7c5c9d80298431d638aba3aa71c66a72ff7fcb" => :mojave
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

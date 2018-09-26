class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.5.tar.gz"
  sha256 "e36937d1d8421134c601e80a42bd535b1d9d7e7dd5bdf4da355e58942ba56006"
  revision 1

  bottle do
    sha256 "98e394f828be396cfcd37081ae13b364f9860266d8f24131ad5e758238401f38" => :mojave
    sha256 "7a50b0d414ee7e4bc690680ea85e3c11f5ddcdfec9b7c709561585b31d36555a" => :high_sierra
    sha256 "b52f8c8e402f64c70651ab06df3ea99fc06eb0767e991bdf53ac94e9b27c80a3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  # These two upstream commits fix build failures with CGAL 4.12.
  # Remove with next version.
  # https://github.com/Oslandia/SFCGAL/pull/168
  patch do
    url "https://github.com/Oslandia/SFCGAL/commit/e47828f7.diff?full_index=1"
    sha256 "5ce8b251a73f9a2f1803ca5d8a455007baedf1a2b278a2d3465af9955d79c09e"
  end

  # https://github.com/Oslandia/SFCGAL/pull/169
  patch do
    url "https://github.com/Oslandia/SFCGAL/commit/2ef10f25.diff?full_index=1"
    sha256 "bc53ce8405b0400d8c37af7837a945dfd96d73cd4a876114f48441fbaeb9d96d"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end

class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.2.tar.gz"
  sha256 "1ae0ce1c38c728b5c98adcf490135b32ab646cf5c023653fb5394f43a34f808a"

  bottle do
    rebuild 1
    sha256 "2f57012f323a07132f74763b8021bc532a5e667be4e679b87b3a63d3b334f3a9" => :high_sierra
    sha256 "1559b5da11beae7c82cfba93eb1fa92a6ac8c54915de42f8075551acaced2557" => :sierra
    sha256 "0939b1b60e794f97ec215fd7e92c73ad2d5ce4af2f4e902aaa39695c1736627d" => :el_capitan
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

class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.3.0.tar.gz"
  sha256 "7ed35439fc197e73790f4c3d1c1750acdc3044968769239b2185a7a845845df3"
  revision 3

  bottle do
    sha256 "ae3ca295f37bb884877f9456450c64ce6eacf5019e20c731ffaec12c249d1b5a" => :sierra
    sha256 "078736b2aba257e4cb2c1601af93b24ca29d9c40504f8305e8d82bec78ff1c7f" => :el_capitan
    sha256 "3a7cb00513b9c68de4710449c8c9db4b2c12f144fb4e666394f62d81b2cb4a06" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "mpfr"
  if build.cxx11?
    depends_on "boost@1.61" => "c++11"
    depends_on "cgal" => "c++11"
    depends_on "gmp"   => "c++11"
  else
    depends_on "boost@1.61"
    depends_on "cgal"
    depends_on "gmp"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end

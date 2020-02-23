class Gammalib < Formula
  desc "Toolbox for the analysis of astronomical gamma-ray data"
  homepage "http://cta.irap.omp.eu/gammalib/about.html"
  url "http://cta.irap.omp.eu/ctools/releases/gammalib/gammalib-1.6.3.tar.gz"
  sha256 "b93bc03562ba1fcb21ab6f48943f9c28230c04d1b0ef986569c88b05d8e9dbbe"

  bottle do
    sha256 "9961247b61760373a37f3ed49de048c691fee84143d400be5d63c19169b8ad6e" => :catalina
    sha256 "10a48d7cac08a467c0e0a8c9ab321708d3a206bf92c9266ef51716d118bfd21d" => :mojave
    sha256 "359db59d17fbda89a3297cea19a1cbee0df79a52c394cda331bcda60506b2acb" => :high_sierra
  end

  depends_on "cfitsio"
  depends_on "doxygen"
  depends_on "python"
  depends_on "readline"
  depends_on "swig"
  uses_from_macos "ncurses"

  def install
    system "./configure", "PYTHON=/usr/local/bin/python3", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Because gammalib expects a set of environment variables you should source:
      export GAMMALIB=/usr/local/
      source $GAMMALIB/bin/gammalib-init.sh
    before using gammalib.
  EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gammalib/GSkyMap.hpp>
      #include <iostream>
      int main() {
        GSkyDir dir;
        dir.radec_deg(83.63,22.01);
        double l = dir.l_deg();
        std::cout << l << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lgamma"
    assert_match /184.56/, shell_output("./test")
  end
end

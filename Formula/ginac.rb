class Ginac < Formula
  desc "Not a Computer algebra system"
  homepage "https://www.ginac.de/"
  url "https://www.ginac.de/ginac-1.7.2.tar.bz2"
  sha256 "24b75b61c5cb272534e35b3f2cfd64f053b28aee7402af4b0e569ec4de21d8b7"

  bottle do
    rebuild 1
    sha256 "946b6150e79c9a2493979873d76e5685776b55afb3e1e57f01e989c3cffc883c" => :sierra
    sha256 "3c9078ed9ee23fc62ba2e8b3a127728adc84305a251b711f2aaa608d86e01b98" => :el_capitan
    sha256 "e31df88157474103a5fba1e6860b0649b598640444a96582c65ceff8be92ae63" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <iostream>
    #include <ginac/ginac.h>
    using namespace std;
    using namespace GiNaC;

    int main() {
      symbol x("x"), y("y");
      ex poly;

      for (int i=0; i<3; ++i) {
        poly += factorial(i+16)*pow(x,i)*pow(y,2-i);
      }

      cout << poly << endl;
      return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}",
                                "-L#{Formula["cln"].lib}",
                                "-lcln", "-lginac", "-o", "test",
                                "-std=c++11"
    system "./test"
  end
end

class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "http://muparser.beltoforion.de/"
  url "https://github.com/beltoforion/muparser/archive/v2.2.5.tar.gz"
  sha256 "0666ef55da72c3e356ca85b6a0084d56b05dd740c3c21d26d372085aa2c6e708"

  head "https://github.com/beltoforion/muparser.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f66bedff2bc6708a7080c2e377ed1f890047d3d6945e64652b488273d4ddc70a" => :sierra
    sha256 "345edaf9dc509d650f19cb19a904434a62fa38c32c838e5ff2494e1395f86d18" => :el_capitan
    sha256 "f0c1e279183af1296de59404408cd1339df7038bd7889a0f47c09a919460525e" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include "muParser.h"

      double MySqr(double a_fVal)
      {
        return a_fVal*a_fVal;
      }

      int main(int argc, char* argv[])
      {
        using namespace mu;
        try
        {
          double fVal = 1;
          Parser p;
          p.DefineVar("a", &fVal);
          p.DefineFun("MySqr", MySqr);
          p.SetExpr("MySqr(a)*_pi+min(10,a)");

          for (std::size_t a=0; a<100; ++a)
          {
            fVal = a;  // Change value of variable a
            std::cout << p.Eval() << std::endl;
          }
        }
        catch (Parser::exception_type &e)
        {
          std::cout << e.GetMsg() << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lmuparser",
           testpath/"test.cpp", "-o", testpath/"test"
    system "./test"
  end
end

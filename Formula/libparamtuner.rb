class Libparamtuner < Formula
  desc "Library to ease the interactive tuning of parameters at run time"
  homepage "https://github.com/casiez/libparamtuner"
  url "https://github.com/casiez/libparamtuner/releases/download/v1.2/libparamtuner-mac-1.2.tar.gz"
  sha256 "baba6c6eb2317573d5ce5e76378599dc075240075671fd2e8990354e40da72ce"

  bottle do
    cellar :any
    sha256 "b75c82efddc83c168e0e50ee553e1e8377426091826f20bdda053ac8330f9d17" => :high_sierra
    sha256 "1a8802c70ef9fecc3b8c8cd31e8a4ee76225159cdb792ab53414b5a8e75bba2a" => :sierra
    sha256 "47874643fda0d72eba828a1226b67a4b302e75014a535e1dd3a693c5674f90c2" => :el_capitan
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <paramtuner.h>
      #include <iostream>

      using namespace std;

      int
      main(int argc, char **argv) {
        double varDouble = 2.0;
        int varInt = 1;
        bool varBool = false;
        string varString;

        ParamTuner::load("test/settings.xml");
        ParamTuner::bind("setting1", &varDouble);
        ParamTuner::bind("setting2", &varInt);
        ParamTuner::bind("mybool", &varBool);
        ParamTuner::bind("mystring", &varString);

        cout << "setting1 (double) = " << varDouble
          << " ; setting2 (int) = " << varInt
          << " ; mybool (bool) = " << varBool
          << " ; mystring (string) = " << varString
          << endl;

        return 0 ;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lparamtuner", "-o", "test"
    system "./test"
  end
end

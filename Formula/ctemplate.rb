class Ctemplate < Formula
  desc "Template language for C++"
  homepage "https://github.com/olafvdspek/ctemplate"
  url "https://github.com/OlafvdSpek/ctemplate/archive/ctemplate-2.3.tar.gz"
  sha256 "99e5cb6d3f8407d5b1ffef96b1d59ce3981cda3492814e5ef820684ebb782556"
  head "https://github.com/olafvdspek/ctemplate.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "548a1d8e26e00c0cb10edf98a7a794006ebfa02b8a00567605d7e2c5070118ae" => :catalina
    sha256 "640e6ea7fcdf4bfd4f287b96a20f5d343d577e1fe6155a9076b553b0de733be9" => :mojave
    sha256 "002d50810065da45df36ee0e2a9bff9bec25e1b75047f891a0c3f3fff85b39c4" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <ctemplate/template.h>
      int main(int argc, char** argv) {
        ctemplate::TemplateDictionary dict("example");
        dict.SetValue("NAME", "Jane Doe");
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lctemplate_nothreads", "test.cpp", "-o", "test"
    system "./test"
  end
end

class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.5.tar.gz"
  sha256 "802537484d4247706f31c121df78b29fc2f26126995963102e19ef378f3c39d2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c328368c34f97a1d3dcb2b49c2077c02e0baf471bd144a821c976d37617ecb5e" => :catalina
    sha256 "a30c17ce291aa0c0e03c55916ae1cbd65e34260a34bb3eb5a1ef7376610c17e5" => :mojave
    sha256 "281ccfaa8ab855a549775f192af0eef52c5614260d5538cec50e947a476b1425" => :high_sierra
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <yazpp/zoom.h>

      using namespace ZOOM;

      int main(int argc, char **argv){
        try
        {
          connection conn("wrong-example.xyz", 210);
        }
        catch (exception &e)
        {
          std::cout << "Exception caught";
        }
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}/src", "-L#{lib}",
           "-lzoompp", "test.cpp", "-o", "test"
    output = shell_output("./test")
    assert_match "Exception caught", output
  end
end

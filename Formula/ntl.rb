class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-10.4.0.tar.gz"
  sha256 "ed72cbfd8318d149ea9ec3a841fc5686f68d0f72e70602d59dd034cde43fab6f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ba6960e1c36a7c0cb1cc28b41073d778b2e3c1044fe3c7d015c71aa63af36304" => :sierra
    sha256 "758d380bf022bd9288fee6dd8a950b554fb315c83a16b3aabb091238dfa0bce3" => :el_capitan
    sha256 "909ea303230fbe81744b80f41023ca887c5214a798d82f53be1430fcd7a6087f" => :yosemite
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    (testpath/"square.cc").write <<-EOS.undent
      #include <iostream>
      #include <NTL/ZZ.h>

      int main()
      {
          NTL::ZZ a;
          std::cin >> a;
          std::cout << NTL::power(a, 2);
          return 0;
      }
    EOS
    gmp = Formula["gmp"]
    flags = %W[
      -I#{include}
      -L#{gmp.opt_lib}
      -L#{lib}
      -lntl
      -lgmp
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end

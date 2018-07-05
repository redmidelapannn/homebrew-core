class Ntl < Formula
  desc "C++ number theory library"
  homepage "https://www.shoup.net/ntl"
  url "https://www.shoup.net/ntl/ntl-11.1.0.tar.gz"
  sha256 "bb4ae214886f95a044ef16fdfd909f8d3181b288470ea7077c9f23d14047302f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e08ce25e75bf45acdd5d3fbfc70f10ba13416431107083fe8a0bb1fc87733e15" => :high_sierra
    sha256 "30209f4c271d2a87bf595ebd39a2c2c088a9fe459591105da7d046bf8075e4d2" => :sierra
    sha256 "f7a54cbd1d0f5861ad0a53ad34ff945a9978acac03af6c50e109f51e7ab4ad83" => :el_capitan
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}", "SHARED=on"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"square.cc").write <<~EOS
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
      -std=c++11
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

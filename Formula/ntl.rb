class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.11.0.tar.gz"
  sha256 "379901709e6abfeaa1ca41fc36e0a746604cc608237c6629058505bfd8ed9cf1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d436c12dd63947346a7de3b2446516e499ef1cf429df640cbba263db36938ed1" => :el_capitan
    sha256 "4239ea776501fb76c35b5fa76f1aac46cd285235dcf8c756b97d0b91cc9b18d1" => :yosemite
    sha256 "7ae2b6cbf3af31a0a498c7955f640e155c6f7b52ac0d728a841de876d3d6f134" => :mavericks
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
      -lgmp
      -lntl
    ]
    system ENV.cxx, "square.cc", "-o", "square", *flags
    assert_equal "4611686018427387904", pipe_output("./square", "2147483648")
  end
end

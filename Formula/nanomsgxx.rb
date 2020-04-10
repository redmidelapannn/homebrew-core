class Nanomsgxx < Formula
  desc "Nanomsg binding for C++11"
  homepage "https://achille-roussel.github.io/nanomsgxx/doc/nanomsgxx.7.html"
  url "https://github.com/achille-roussel/nanomsgxx/archive/0.2.tar.gz"
  sha256 "116ad531b512d60ea75ef21f55fd9d31c00b172775548958e5e7d4edaeeedbaa"
  revision 2

  bottle do
    cellar :any
    rebuild 3
    sha256 "c64ac0508dcd022defd6b1b3594cfea0f5ac23f8f330e94c5b4f709908951e38" => :catalina
    sha256 "f2dea70260341feaf5718c8d0401e7220e253647e904c2c705238986ab7ba20b" => :mojave
    sha256 "155afa92f54e999c63e2f2d4c9bb1d1c7d377226cab4e059a82a92e4597a197a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on :macos # Due to Python 2
  depends_on "nanomsg"

  def install
    args = %W[
      --static
      --shared
      --prefix=#{prefix}
    ]

    system "python", "./waf", "configure", *args
    system "python", "./waf", "build"
    system "python", "./waf", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main(int argc, char **argv) {
        std::cout << "Hello Nanomsgxx!" << std::endl;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lnnxx", "test.cpp"

    assert_equal "Hello Nanomsgxx!\n", shell_output("#{testpath}/a.out")
  end
end

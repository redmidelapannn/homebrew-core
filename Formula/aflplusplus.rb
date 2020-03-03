class Aflplusplus < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/vanhauser-thc/AFLplusplus"
  url "https://github.com/vanhauser-thc/AFLplusplus/archive/2.62c.tar.gz"
  sha256 "cde181ac733aa3a1212ffcb494bb9306a2086c7521fb006719b0e15cd8015c63"

  bottle do
    sha256 "61201b88a4bc6eba2c6260cf7cda79243fd618311a14dda1e8e6425371271969" => :catalina
    sha256 "d712b50534452f1660d0366785190d110a1dd2ef110a9d69e5102a8620f9f951" => :mojave
    sha256 "40503a37e653faf5df88af49dfd539461d6e4171c0f54efb7b563700d9ec6668" => :high_sierra
  end

  depends_on "automake" => :build

  conflicts_with "afl-fuzz"

  def install
    system "make", "source-only", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end

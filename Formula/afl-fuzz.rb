class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.56b.tar.gz"
  sha256 "1d4a372e49af02fbcef0dc3ac436d03adff577afc2b6245c783744609d9cdd22"

  bottle do
    rebuild 1
    sha256 "7dc10c4e66db83f756c14510293e185379af29ddb51abc0f5067080347cd9072" => :catalina
    sha256 "5102f7a2c46f00bc96fe6e49ba8c5051e3e264ab7f3cde81f9b0d1b8b46330ae" => :mojave
    sha256 "85e1575f237cfd13a2b2300345509566f08e2f850339f4d41ac2b461a3a751e5" => :high_sierra
  end

  conflicts_with "aflplusplus"

  def install
    system "make", "PREFIX=#{prefix}"
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

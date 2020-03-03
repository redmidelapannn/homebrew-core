class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "https://github.com/google/AFL"
  url "https://github.com/google/AFL/archive/v2.56b.tar.gz"
  sha256 "1d4a372e49af02fbcef0dc3ac436d03adff577afc2b6245c783744609d9cdd22"

  bottle do
    rebuild 1
    sha256 "ceaee7f4b72afe750dc727f0fb0d25e4a447779a0b69ff67b128b57ef8a4742f" => :catalina
    sha256 "80b851e4f166352cc43d98abda574f42470d0e72c24ac722a35f7dc0c81ff8b5" => :mojave
    sha256 "51ff560d71805f28a39ac6a157d4b85e97cf64356a2f620a078828e7efc6bd6a" => :high_sierra
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

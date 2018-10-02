class Cityhash < Formula
  desc "Hash functions for strings"
  homepage "https://github.com/google/cityhash"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cityhash/cityhash-1.1.1.tar.gz"
  sha256 "76a41e149f6de87156b9a9790c595ef7ad081c321f60780886b520aecb7e3db4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bbe6898750b18f411cf7e7fa4be367cc10bf3e9bb8506e87d4d5d5ded154137c" => :mojave
    sha256 "ca91d419f80d02e09b404e574b249361e63b5f5d2441dc8163d67ecd7c82506a" => :high_sierra
    sha256 "f7e913b2c7a14fd218f44adc9fe220b02de5e892cbb968d19561dafe5f919ad0" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      #include <city.h>

      int main() {
        const char* a = "This is my test string";
        uint64_t result = CityHash64(a, sizeof(a));
        printf("result: %llx\\n", result);
        return result != 0xab7a556ed7598b04LL;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lcityhash", "test.cpp", "-o", "test"
    system "./test"
  end
end

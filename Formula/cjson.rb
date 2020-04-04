class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.13.tar.gz"
  sha256 "d4e77a38f540f2c37f55758f2666655314f1f51c716fea5f279659940efdcf04"

  bottle do
    cellar :any
    sha256 "c2ca30995167c55daacf99a66a3c86ce6dc22b9dc887e7e26c2ae98c5a429c3b" => :catalina
    sha256 "f2b0d6242519da72b4e84c694af3657e1738fdec1bf671ab5f4945040c3cef87" => :mojave
    sha256 "750085fd5fb22d6a1ad7c19035b657e46ab6e6e739c628024537740b54077d1b" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DENABLE_CJSON_UTILS=On", "-DENABLE_CJSON_TEST=Off",
                    "-DBUILD_SHARED_AND_STATIC_LIBS=On", ".",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cjson/cJSON.h>

      int main()
      {
        char *s = "{\\"key\\":\\"value\\"}";
        cJSON *json = cJSON_Parse(s);
        if (!json) {
            return 1;
        }
        cJSON *item = cJSON_GetObjectItem(json, "key");
        if (!item) {
            return 1;
        }
        cJSON_Delete(json);
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lcjson", "test.c", "-o", "test"
    system "./test"
  end
end

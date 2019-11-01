 class Libcbor < Formula
   desc "CBOR format implementation for C"
  bottle do
    cellar :any
    sha256 "d1f249e7c60ea01884649528acf102fb5eb2b586f6654a5991f46d35be878337" => :catalina
    sha256 "9bd1f63ac8b46eb4c6973f1ecd86e47aa21961548b4e67b3773f836860a929dd" => :mojave
    sha256 "811869b1a7c244270e7b8baac34ad1b59aa18047668099fad7f36f76eb24082d" => :high_sierra
  end

   homepage "http://libcbor.org/"
   url "https://github.com/PJK/libcbor/archive/v0.5.0.tar.gz"
   sha256 "9bbec94bb385bad3cd2f65482e5d343ddb97e9ffe261123ea0faa3bfea51d320"

   depends_on "cmake" => :build

   def install
     mkdir "build" do
       system "cmake", "-G", "Unix Makefiles", "..", *std_cmake_args
       system "make"
       system "make", "install"
     end
   end

   test do
     (testpath/"example.c").write <<-EOS
       #include "cbor.h"
       #include <stdio.h>

       int main(int argc, char * argv[])
       {
         printf("Hello from libcbor %s\\n", CBOR_VERSION);
         printf("Custom allocation support: %s\\n", CBOR_CUSTOM_ALLOC ? "yes" : "no");
         printf("Pretty-printer support: %s\\n", CBOR_PRETTY_PRINTER ? "yes" : "no");
         printf("Buffer growth factor: %f\\n", (float) CBOR_BUFFER_GROWTH);
       }
     EOS

     system ENV.cc, "-std=c99", "example.c", "-L#{lib}", "-lcbor", "-o", "example"
     system "./example"
     puts `./example`
   end
 end

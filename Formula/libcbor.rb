class Libcbor < Formula
  desc "CBOR protocol implementation for C and others"
  homepage "http://libcbor.org/"
  url "https://github.com/PJK/libcbor/archive/v0.6.1.tar.gz"
  sha256 "2f805f5fa2790c4fdd16046287f5814703229547da2b83009dd32357623aa182"

  bottle do
    cellar :any
    sha256 "7594764030c94fb81df3feab177612a61718f25bcd3c6063a395ba40fd8741be" => :catalina
    sha256 "5608fa9fc2ea2c093896b9ac9fed562079154464d4e08eafb791de4977119df3" => :mojave
    sha256 "8666be947155c1a818d3ebafc158c0e16f257bfce390757c2858542d66bbcda0" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_EXAMPLES=OFF", *std_cmake_args
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

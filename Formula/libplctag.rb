class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.0.31.tar.gz"
  sha256 "9106381ae2ee742360ec2a2d7bbdcd1b4a4caabfa7037a5315364382b7b5335a"

  bottle do
    cellar :any
    sha256 "5f2970ca79b2edbeb73afb8d865dbd26a23fb9339cde097dcdb08d1fce284e2e" => :catalina
    sha256 "76ff5bc8f4816b1f4d2db17a53e3095f07265d9df334da2ec574091aa6ec1038" => :mojave
    sha256 "a1a3f987dbf2e75de8a57acc425abf263468e30ac8b26ec28f79356511b34af2" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        plc_tag tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray");
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end

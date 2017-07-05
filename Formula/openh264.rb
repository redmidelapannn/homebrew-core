class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "http://www.openh264.org"
  url "https://github.com/cisco/openh264/archive/v1.7.0.tar.gz"
  sha256 "9c07c38d7de00046c9c52b12c76a2af7648b70d05bd5460c8b67f6895738653f"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ba13d85d14a79c2d615fc02e35cd86637e4d38e93687cebb439daf53ac59fc65" => :sierra
    sha256 "cca12734b7999c8348d115a44c0c87ce984353d74c947f999e3a06929a7832ba" => :el_capitan
    sha256 "e729b1c60b0c3bf9b864b6d9fa7b362401b1102ba0e3094c0735f89e25f4b61a" => :yosemite
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
    chmod 0444, "#{lib}/libopenh264.dylib"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lopenh264", "-o", "test"
    system "./test"
  end
end

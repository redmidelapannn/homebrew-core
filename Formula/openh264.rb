class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/v1.7.0.tar.gz"
  sha256 "9c07c38d7de00046c9c52b12c76a2af7648b70d05bd5460c8b67f6895738653f"
  head "https://github.com/cisco/openh264.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "45ff0bd9b57d6458ae66ee8d433a190153ae7f7ca521296f07d68e72cc8b7d0f" => :high_sierra
    sha256 "3ec0e82ecacf8a66751cf086a558539f195df5336b617f0139a6b1c578749cf7" => :sierra
    sha256 "f7ec6b4c8c621620e2850c8bc4aa3ff0ac7e462095bc0df90d4696c7482196ba" => :el_capitan
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
    chmod 0444, "#{lib}/libopenh264.dylib"
  end

  test do
    (testpath/"test.c").write <<~EOS
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

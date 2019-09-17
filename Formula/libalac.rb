class Libalac < Formula
  desc "Apple Lossless Audio Codec (ALAC) Library"
  homepage "https://github.com/mikebrady/alac"
  url "https://github.com/mikebrady/alac/archive/0.0.7.tar.gz"
  sha256 "5a2b059869f0d0404aa29cbde44a533ae337979c11234041ec5b5318f790458e"
  head "https://github.com/mikebrady/alac.git"

  bottle do
    cellar :any
    sha256 "b8c0d31e286ade16b1afded85f5a24bef28ed8888edec817662a06fda4dc758b" => :mojave
    sha256 "1e07047dd45c339a623fc2ec90f59b43648cc2795d47bab360b9d5ca6e6bde1c" => :high_sierra
    sha256 "7bcfcdca9cdf745a6e6caf96e3d1725c5d3dc7d72facdd1123d2d64652de210f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <assert.h>
      #include <alac/ALACEncoder.h>
      #include <alac/ALACDecoder.h>

      int main() {
        uint32_t   frameSize = kALACDefaultFramesPerPacket;
        uint8_t    *magicCookie = (uint8_t *)calloc(1337, 1);

        ALACEncoder *theEncoder = new ALACEncoder;
        theEncoder->SetFrameSize(frameSize);
        assert(theEncoder != NULL);

        ALACDecoder *theDecoder = new ALACDecoder;
        theDecoder->Init(magicCookie, 1337);
        assert(theDecoder != NULL);

        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lalac
    ]
    system ENV.cxx, testpath/"test.cpp", "-o", "test", *flags
    system "./test"
  end
end

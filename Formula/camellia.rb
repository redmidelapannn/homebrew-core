class Camellia < Formula
  desc "Image Processing & Computer Vision library written in C"
  homepage "https://camellia.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/camellia/Unix_Linux%20Distribution/v2.7.0/CamelliaLib-2.7.0.tar.gz"
  sha256 "a3192c350f7124d25f31c43aa17e23d9fa6c886f80459cba15b6257646b2f3d2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4a2433197a94d8fd103277eec1935c19ef26e58517f9d94c5dc3ee1e02fd3dfa" => :catalina
    sha256 "ad2c33f0b077f501f746e1b8a250dc8f3b9587670502e270fb6d96275b29e7d8" => :mojave
    sha256 "b68046cf8a380e1368fc65a9d51883aeed4cfe6f08aaa70f494afbc2ae0c9361" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "camellia.h"
      int main() {
        CamImage image; // CamImage is an internal structure of Camellia
        return 0;
      }
    EOS

    system ENV.cc, "-I#{include}", "-L#{lib}", "-lcamellia", "-o", "test", "test.cpp"
    system "./test"
  end
end

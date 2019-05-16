class LiquidDsp < Formula
  desc "Digital signal processing library for software-defined radios"
  homepage "https://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.3.1.tar.gz"
  sha256 "e3f66ce72a3b5d74eea5ccffb049c62c422c91b0ab92d6dbbef21af3c3bfec73"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4eb251ba85424f274a52a67db467a4beb7ad62826a298fb7791b7938ed517f0b" => :mojave
    sha256 "5f776c863edc86e127be36adc56ecd376f5690e64ba98b89adeea62c0e9585f0" => :high_sierra
    sha256 "81605a5c46f27d4b9b67559d654b03f1f1f7dfc311a8de6fe1233cfd570268bd" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fftw"

  def install
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <liquid/liquid.h>
      int main() {
        if (!liquid_is_prime(3))
          return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lliquid"
    system "./test"
  end
end

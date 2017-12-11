class ZitaConvolver < Formula
  desc "Fast, partitioned convolution engine library"
  homepage "https://kokkinizita.linuxaudio.org/linuxaudio/"
  url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-3.1.0.tar.bz2"
  sha256 "bf7e93b582168b78d40666974460ad8142c2fa3c3412e327e4ab960b3fb31993"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3ffafe099dd1383e7bcc1d15f18fa3bce8c59c5596502fc781a4c2cb28e00b4d" => :high_sierra
    sha256 "8e1045b2c26ce630e3e68b763104b296c9ac5912da89d470bae6b12915723904" => :sierra
    sha256 "bef2de03f1182a9337e4f3ad508eac2152cfe6ce3604b1054f6dfe199fac2157" => :el_capitan
  end

  depends_on "fftw"

  def install
    cd "libs" do
      system "make", "-f", "Makefile-osx", "install", "PREFIX=#{prefix}", "SUFFIX="
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <zita-convolver.h>

      int main() {
        return zita_convolver_major_version () != ZITA_CONVOLVER_MAJOR_VERSION;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzita-convolver", "-o", "test"
    system "./test"
  end
end

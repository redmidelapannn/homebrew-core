class ZitaConvolver < Formula
  desc "Fast, partitioned convolution engine library"
  homepage "https://kokkinizita.linuxaudio.org/linuxaudio/"
  url "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-4.0.2.tar.bz2"
  sha256 "1245451c52a33ef3476ffc4007a9e100ee282df0648c961be235b6a8ef748e77"

  bottle do
    cellar :any
    sha256 "54d08d1e1032da23d22c504d5ce68d2b5fa181ccdadee63fca214597510682db" => :high_sierra
    sha256 "88dd865f48669cfe4cb9fb8a16213d454dc972acb157e9d84134934356370e07" => :sierra
    sha256 "e7fa68f1b137c824d5884e7591be5a827b284e006595c2c2489c88150c383b34" => :el_capitan
  end

  depends_on "fftw"

  def install
    cd "source" do
      inreplace "Makefile" do |s|
        s.gsub! ".so", ".dylib"
        s.gsub! "-soname", "-install_name"
        s.gsub! "ldconfig", ""
      end

      system "make", "install", "PREFIX=#{prefix}", "SUFFIX="
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

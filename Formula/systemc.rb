class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://accellera.org/"
  url "https://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.tar.gz"
  sha256 "5781b9a351e5afedabc37d145e5f7edec08f3fd5de00ffeb8fa1f3086b1f7b3f"

  bottle do
    cellar :any
    sha256 "9e3ec9355d24df5e135cb52eb1ab89d50992892dad7122879c777c9d86ad2f28" => :catalina
    sha256 "760aac05ae7bcaddd08224b10adac6ed64f4ae30805130f6a3e3c7b4fd188fdf" => :mojave
    sha256 "7fa6468ffe6943083ba6dac67266f9212f201a21d3b27f7c710289ea3394d1a0" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-arch-suffix=",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end

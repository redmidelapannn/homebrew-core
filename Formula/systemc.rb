class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://accellera.org/"
  url "https://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.tar.gz"
  sha256 "5781b9a351e5afedabc37d145e5f7edec08f3fd5de00ffeb8fa1f3086b1f7b3f"

  bottle do
    cellar :any
    sha256 "e815f35612f040c78d58baef22db7cc386362052d8490e6a90e0c0f04124b8a5" => :mojave
    sha256 "da394af3c3e25ddb2063a59491eea95d1e21272d127bf7ffaa07d9b187c78f77" => :high_sierra
    sha256 "b5ed49ff049ea66401e4a92df0681c805e9ef133fbff6052172c4f425a793cd5" => :sierra
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

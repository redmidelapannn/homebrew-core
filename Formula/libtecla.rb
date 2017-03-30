class Libtecla < Formula
  desc "Command-line editing facilities similar to the tcsh shell"
  homepage "http://www.astro.caltech.edu/~mcs/tecla/index.html"
  url "http://www.astro.caltech.edu/~mcs/tecla/libtecla-1.6.3.tar.gz"
  sha256 "f2757cc55040859fcf8f59a0b7b26e0184a22bece44ed9568a4534a478c1ee1a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8b246fb87cff63a5fa904e51dacfc8d572591572831891518928227aad1e7833" => :sierra
    sha256 "1cb2953560bd80c0eb88e258dac06297ce24c86dfffe80e5c9b17f10022d5e00" => :el_capitan
    sha256 "dc983c2d3f482f04bbb9ac688682a88f74b3026b07d928e81d3f7bdc3e20725c" => :yosemite
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <locale.h>
      #include <libtecla.h>

      int main(int argc, char *argv[]) {
        GetLine *gl;
        setlocale(LC_CTYPE, "");
        gl = new_GetLine(1024, 2048);
        if (!gl) return 1;
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-ltecla", "-o", "test"
    system "./test"
  end
end

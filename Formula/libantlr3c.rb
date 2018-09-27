class Libantlr3c < Formula
  desc "ANTLRv3 parsing library for C"
  homepage "https://www.antlr3.org/"
  url "https://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz"
  sha256 "ca914a97f1a2d2f2c8e1fca12d3df65310ff0286d35c48b7ae5f11dcc8b2eb52"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "fa4811df339a326c4fa8c543dd349750a4594d357b495410663064aa90de3452" => :mojave
    sha256 "9734ac6246087d1e9ffda83acf6b0ff486b5e558a5b3b91db15245459f39ba7b" => :high_sierra
    sha256 "c4dad638f8c17b0a8eaa0e4f94aa076b1d712761decc5c134a8b66324b72e1c0" => :sierra
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-antlrdebug",
            "--prefix=#{prefix}"]
    args << "--enable-64bit" if MacOS.prefer_64_bit?
    system "./configure", *args

    inreplace "Makefile" do |s|
      cflags = s.get_make_var "CFLAGS"
      cflags = cflags << " -fexceptions"
      s.change_make_var! "CFLAGS", cflags
    end

    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <antlr3.h>
      int main() {
        if (0) {
          antlr3GenericSetupStream(NULL);
        }
        return 0;
      }
    EOS
    system ENV.cc, "hello.c", "-L#{lib}", "-lantlr3c", "-o", "hello", "-O0"
    system testpath/"hello"
  end
end

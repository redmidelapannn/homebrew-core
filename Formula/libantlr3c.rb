class Libantlr3c < Formula
  desc "ANTLRv3 parsing library for C"
  homepage "https://www.antlr3.org/"
  url "https://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz"
  sha256 "ca914a97f1a2d2f2c8e1fca12d3df65310ff0286d35c48b7ae5f11dcc8b2eb52"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "03a9a9be99ef6ff3e4b96c0ce94e77a2a50aee6c1bbe4211ff5b2c2b93c4fda3" => :high_sierra
    sha256 "fe8514843729bbe531e74a2a350b971d3ce52e8232106004b53eaaf161dedf1b" => :sierra
    sha256 "f130a26d371019b4c167942635471252477e0ec58908d15acda4840a0338eb3e" => :el_capitan
  end

  option "without-exceptions", "Compile without support for exception handling"

  def install
    args = ["--disable-dependency-tracking",
            "--disable-antlrdebug",
            "--prefix=#{prefix}"]
    args << "--enable-64bit" if MacOS.prefer_64_bit?
    system "./configure", *args
    if build.with? "exceptions"
      inreplace "Makefile" do |s|
        cflags = s.get_make_var "CFLAGS"
        cflags = cflags << " -fexceptions"
        s.change_make_var! "CFLAGS", cflags
      end
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

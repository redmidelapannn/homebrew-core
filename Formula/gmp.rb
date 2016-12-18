class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.1.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.xz"
  sha256 "d36e9c05df488ad630fff17edb50051d6432357f9ce04e34a09b3d818825e831"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bbb9036cedb3aa2eef7ca783dfcf4e4383e7e4440cec20d368215566a9963f69" => :sierra
    sha256 "e2e0d9d9ee7e2d5915010516b20313ec0c2db9b618d602eab62ba4560ad44c2d" => :el_capitan
    sha256 "a6be18bc801fb9c66d8d9203dfbd7291d07ea2e2ce6e95972f31ed7af76fdb94" => :yosemite
  end

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    # https://github.com/Homebrew/homebrew/issues/20693
    args << "--disable-assembly" if build.bottle?

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gmp.h>

      int main()
      {
        mpz_t integ;
        mpz_init (integ);
        mpz_clear (integ);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"
  end
end

class PplAT011 < Formula
  desc "Numerical abstractions for analysis, verification"
  homepage "http://bugseng.com/products/ppl/"
  # Track gcc infrastructure releases.
  url "http://bugseng.com/products/ppl/download/ftp/releases/0.11/ppl-0.11.tar.gz"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/ppl-0.11.tar.gz"
  sha256 "3453064ac192e095598576c5b59ecd81a26b268c597c53df05f18921a4f21c77"
  revision 1

  bottle do
    rebuild 2
    sha256 "9bd52900794a34b1f114ccba20b0c56c169a1d3725180306534e9c05f3819d58" => :sierra
    sha256 "5d6a7099c0d46bc02e284cef512f6c83b13b978c887424650c3b9babc6e02500" => :el_capitan
    sha256 "fe3d666634f7cee053a6fdbf69174f227d20ec3395ea944f6d71b5c99ffea921" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "m4" => :build if MacOS.version < :leopard
  depends_on "gmp@4"

  # https://www.cs.unipr.it/mantis/view.php?id=596
  # https://github.com/Homebrew/homebrew/issues/27431
  # Using different patch from upstream bug report to avoid autoreconf.
  patch do
    url "https://gist.githubusercontent.com/manphiz/9507743/raw/45081e12c2f1faf81e8536f365af05173c6dab5c/patch-ppl-flexible-array-clang_v2.patch"
    sha256 "db8ced5366ec4c3efb6fd20d3b4e440de3f8b9ec1d930a33b6a23d006dc25944"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppl_lpsol",
                          "--disable-ppl_lcdd",
                          "--disable-ppl_pips",
                          "--with-gmp-prefix=#{Formula["gmp@4"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ppl_c.h>
      #ifndef PPL_VERSION_MAJOR
      #error "No PPL header"
      #endif
      int main() {
        ppl_initialize();
        return ppl_finalize();
      }
    EOS
    gmp = Formula["gmp@4"]
    system ENV.cc, "test.c", "-o", "test",
                   "-lgmp", "-I#{gmp.include}", "-L#{gmp.lib}",
                   "-lppl_c", "-lppl", "-I#{include}", "-L#{lib}"
    system "./test"
  end
end

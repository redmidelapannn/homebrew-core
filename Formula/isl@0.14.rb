class IslAT014 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.14.tar.bz2"
  mirror "http://isl.gforge.inria.fr/isl-0.14.tar.bz2"
  sha256 "7e3c02ff52f8540f6a85534f54158968417fd676001651c8289c705bd0228f36"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f95f2228516fe2a809f6bafac328c84e46a60a586b54367e9c4f3e65abe98ffb" => :high_sierra
    sha256 "b99c1861b9e84cae455f51438f62a3c7e73ad3bce103bf129084465a1d544ba1" => :sierra
    sha256 "6459c603ca7dcae3ab72c8956ff7fc6caa3ada33ed09ceef25220ae53e8a25e7" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end

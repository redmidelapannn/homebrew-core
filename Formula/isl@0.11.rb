class IslAT011 < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://freecode.com/projects/isl"
  # Track gcc infrastructure releases.
  url "https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.11.1.tar.bz2"
  mirror "http://isl.gforge.inria.fr/isl-0.11.1.tar.bz2"
  sha256 "095f4b54c88ca13a80d2b025d9c551f89ea7ba6f6201d701960bfe5c1466a98d"

  bottle do
    cellar :any
    rebuild 2
    sha256 "24c58e6cd8cc23d3859dd00554a6bc466a5e28edd6049d0a4d784da52f093535" => :high_sierra
    sha256 "d308e3c246e4f69c2efb8756c437204d580c412fc8513fdf60e253c3cecfaffe" => :sierra
    sha256 "b8cd7a1ec2f6a112360fa3b716fdad57d85b90f6ddd5b0f2d4600989f1dc71f3" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "gmp@4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp@4"].opt_prefix}"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lisl",
      "-I#{include}", "-I#{Formula["gmp@4"].include}", "-o", "test"
    system "./test"
  end
end

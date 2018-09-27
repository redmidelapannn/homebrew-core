class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v7.6.8/gc-7.6.8.tar.gz"
  sha256 "040ac5cdbf1bebc7c8cd4928996bbae0c54497c151ea5639838fa0128102e258"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5cee59c58637392234e1a0cace7cb67c9c23d1054b64f6dfd66b75d464da14aa" => :mojave
    sha256 "a31eaff30446c72541515f195b7f5e59a4a8dd50eb67d853397d2166be363ee6" => :high_sierra
    sha256 "7523f1331dcd51cf2ba39f3fad052a2dc706dc3f2940bd8cdf5d32232dfad24c" => :sierra
  end

  head do
    url "https://github.com/ivmai/bdwgc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include "gc.h"

      int main(void)
      {
        int i;

        GC_INIT();
        for (i = 0; i < 10000000; ++i)
        {
          int **p = (int **) GC_MALLOC(sizeof(int *));
          int *q = (int *) GC_MALLOC_ATOMIC(sizeof(int));
          assert(*p == 0);
          *p = (int *) GC_REALLOC(q, 2 * sizeof(int));
        }
        return 0;
      }
    EOS

    system ENV.cc, "-I#{include}", "-L#{lib}", "-lgc", "-o", "test", "test.c"
    system "./test"
  end
end

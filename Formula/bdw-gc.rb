class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "http://www.hboehm.info/gc/"
  url "http://www.hboehm.info/gc/gc_source/gc-7.6.0.tar.gz"
  sha256 "a14a28b1129be90e55cd6f71127ffc5594e1091d5d54131528c24cd0c03b7d90"

  bottle do
    rebuild 1
    sha256 "ac90e86bad817997b911fa0216bed1fef30a5f93a3493f43fa32e55bb7314705" => :sierra
    sha256 "897f6f279b420f013ed030835baf013fbe400592bcb1b2669d11c53f9bb0cd64" => :el_capitan
    sha256 "fd498d2fe3101f253f3f5f605e557c9ad18b68bafe5eabd7a7862bf88ffdcdc8" => :yosemite
  end

  head do
    url "https://github.com/ivmai/bdwgc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libatomic_ops" => :build

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
    (testpath/"test.c").write <<-EOS.undent
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

class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr/"
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.20.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/i/isl/isl_0.20.orig.tar.xz"
  sha256 "a5596a9fb8a5b365cb612e4b9628735d6e67e9178fae134a816ae195017e77aa"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ea72590617750682337eb1088fe964845cee80d0283afad9e54018bef3c850cb" => :mojave
    sha256 "c264242b7db1156ce6f95c8284ecf39701728c6d2ce3d5ea35c1d2b73cf40c00" => :high_sierra
    sha256 "cd24489cd33595eaeaff8e3068dee72fd73b9f6ee435d3de00885cc2ad4081fa" => :sierra
  end

  head do
    url "https://repo.or.cz/isl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "check"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end

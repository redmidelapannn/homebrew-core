class Jemalloc < Formula
  desc "malloc implementation emphasizing fragmentation avoidance"
  homepage "http://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.0.1/jemalloc-5.0.1.tar.bz2"
  sha256 "4814781d395b0ef093b21a08e8e6e0bd3dab8762f9935bbfb71679b0dea7c3e9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5d4fcfcb9da70d0094642d41f9140fa879cd64e31fc1b403e0a90cb42d82002b" => :high_sierra
    sha256 "6d392f506c65cc8ab5d23e041087f2e80901bf56d9cfcef71cde3f1de41c36b6" => :sierra
    sha256 "32ccdea8ae81ceb7b7966b813754b611faab247db81791f1be8ac8bb4add98b6" => :el_capitan
  end

  head do
    url "https://github.com/jemalloc/jemalloc.git", :branch => "dev"

    depends_on "autoconf" => :build
    depends_on "docbook-xsl" => :build
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-jemalloc-prefix=
    ]

    if build.head?
      args << "--with-xslroot=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
      system "./autogen.sh", *args
      system "make", "dist"
    else
      system "./configure", *args
    end

    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jemalloc/jemalloc.h>

      int main(void) {

        for (size_t i = 0; i < 1000; i++) {
            // Leak some memory
            malloc(i * 100);
        }

        // Dump allocator statistics to stderr
        malloc_stats_print(NULL, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ljemalloc", "-o", "test"
    system "./test"
  end
end

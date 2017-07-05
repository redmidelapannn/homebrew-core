class R3 < Formula
  desc "High-performance URL router library"
  homepage "https://github.com/c9s/r3"
  url "https://github.com/c9s/r3/archive/1.3.4.tar.gz"
  sha256 "db1fb91e51646e523e78b458643c0250231a2640488d5781109f95bd77c5eb82"
  head "https://github.com/c9s/r3.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "02ae3fef6bcac0699bdeab36dbb731f58701f5f1fe80e96530a60aa5cc84dd36" => :sierra
    sha256 "4b0bb8190054a35b051fc5181c524f45c5a035ac66806744a3ec7413ccb9b73d" => :el_capitan
    sha256 "3df714dbe569b6ba658c669e450cf7ba1203ed1eacdbc18af6497ee8605a30b3" => :yosemite
  end

  option "with-graphviz", "Enable Graphviz functions"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "graphviz" => :optional
  depends_on "jemalloc" => :recommended

  def install
    system "./autogen.sh"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-graphviz" if build.with? "graphviz"
    args << "--with-malloc=jemalloc" if build.with? "jemalloc"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "r3.h"
      int main() {
          node * n = r3_tree_create(1);
          r3_tree_free(n);
          return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-L#{lib}", "-lr3", "-I#{include}/r3"
    system "./test"
  end
end

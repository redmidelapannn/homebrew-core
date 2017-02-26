class R3 < Formula
  desc "High-performance URL router library"
  homepage "https://github.com/c9s/r3"
  url "https://github.com/c9s/r3/archive/1.3.4.tar.gz"
  sha256 "db1fb91e51646e523e78b458643c0250231a2640488d5781109f95bd77c5eb82"
  head "https://github.com/c9s/r3.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "88ad7fb21d6fd1c87747c20f6a226a7b754c08bfa2408bcb5fbdaa7ebd97229b" => :sierra
    sha256 "f16f8fe7074e5cc3813e33a5157fdf1033bf85be20c240f4144c60383be41a58" => :el_capitan
    sha256 "5c6ea67bb89f8fa9b51cbaa92f6fdcb3d0d9a4ffff3a06fd156a97455d282062" => :yosemite
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
                  "-lr3", "-I#{include}/r3"
    system "./test"
  end
end

class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-0.16.0/apache-arrow-0.16.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.16.0/apache-arrow-0.16.0.tar.gz"
  sha256 "261992de4029a1593195ff4000501503bd403146471b3168bd2cc414ad0fb7f5"
  head "https://github.com/apache/arrow.git"

  bottle do
    rebuild 1
    sha256 "5bd94c780bc2a62be9f6b28121226155ae0534106f30e8e55770f0cfa395a0a9" => :catalina
    sha256 "6ca524c3900a121301c83a6680201523743c60901c3a1bbadea29ede6534d132" => :mojave
    sha256 "3a7c68ed67525a55c3cccf9e80fbf18337ac79e60b7b81b3d73745ad615c3547" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  def install
    cd "c_glib" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~SOURCE
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    SOURCE
    apache_arrow = Formula["apache-arrow"]
    glib = Formula["glib"]
    flags = %W[
      -I#{include}
      -I#{apache_arrow.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{apache_arrow.opt_lib}
      -L#{glib.opt_lib}
      -DNDEBUG
      -larrow-glib
      -larrow
      -lglib-2.0
      -lgobject-2.0
      -lgio-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

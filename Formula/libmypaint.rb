class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.3.0/libmypaint-1.3.0.tar.xz"
  sha256 "6a07d9d57fea60f68d218a953ce91b168975a003db24de6ac01ad69dcc94a671"
  revision 1

  bottle do
    cellar :any
    sha256 "9a62bf69e90a6f395e6e31f2683e778547113cd04c585fd3a24e72a2b3e27542" => :high_sierra
    sha256 "275130021755a39d02f69b8fe8bfaf6ee698edf475995cd9ff6387847865418f" => :sierra
    sha256 "e8ada4c1cd073840b5bc9a8addfc0078dd3562fc5981314bb1be781772743c12" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "json-c"

  def install
    system "./configure", "--disable-introspection",
                          "--without-glib",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mypaint-brush.h>
      int main() {
        MyPaintBrush *brush = mypaint_brush_new();
        mypaint_brush_unref(brush);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libmypaint", "-L#{lib}", "-lmypaint", "-o", "test"
    system "./test"
  end
end

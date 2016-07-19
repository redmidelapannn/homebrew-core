class PangoxCompat < Formula
  desc "Library for laying out and rendering of text"
  homepage "http://pango.org"
  url "https://download.gnome.org/sources/pangox-compat/0.0/pangox-compat-0.0.2.tar.xz"
  sha256 "552092b3b6c23f47f4beee05495d0f9a153781f62a1c4b7ec53857a37dfce046"
  revision 1

  bottle do
    revision 1
    sha256 "6b91c114cac720f3e085000763c8b524125ce394a815184bb46427b8157462b7" => :el_capitan
    sha256 "ceb5ca6d705a417492c99b7b0f33b2067ec6d955e126a9c7be55cbdbfc0d16de" => :yosemite
    sha256 "7086b62db27dc7a75bc3e8c56e15e05b4096e45b3b1ebcb8d16546252eb97b3b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "pango"
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <pango/pangox.h>
      #include <string.h>

      int main(int argc, char *argv[]) {
        return strcmp(PANGO_RENDER_TYPE_X, "PangoRenderX");
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    pango = Formula["pango"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/pango-1.0
      -I#{pango.opt_include}/pango-1.0
      -I#{MacOS::X11.include}
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -L#{MacOS::X11.lib}
      -lX11
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lpango-1.0
      -lpangox-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

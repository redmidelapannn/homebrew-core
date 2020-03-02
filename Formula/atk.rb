class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.35/atk-2.35.1.tar.xz"
  sha256 "be9360fa3f845e91f001c20e73b3a0315b38983411b1dc008195f779ac543884"

  bottle do
    cellar :any
    sha256 "bfc46d47dbbad6754d20eee758b5a9f6857e5038228cb8dac1211751cb6a6e4f" => :catalina
    sha256 "2280c7c5a21b9cb8fd9252ae75c817b4766d92f6988361a7659e64329c34ded6" => :mojave
    sha256 "e3d47759ca21d14d7e4380137a2a3a1592285f048b96654cac65f17e6eba163b" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/atk-1.0
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -latk-1.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

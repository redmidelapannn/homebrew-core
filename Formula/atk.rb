class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.32/atk-2.32.0.tar.xz"
  sha256 "cb41feda7fe4ef0daa024471438ea0219592baf7c291347e5a858bb64e4091cc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c4a57d8a2df22877ccde2819e64b4164510291423883db42ee25a1fd7c8a584f" => :mojave
    sha256 "4876eaa8d3dfb3c929740c01cb74a35c65ab4d17bedf6c53705a49ce0fd3dfce" => :high_sierra
    sha256 "034667c34ec5bf7eb578a3d736fd20b97c20648dc262ade311e9fda5a1b49eb3" => :sierra
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

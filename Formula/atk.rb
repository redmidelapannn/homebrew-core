class Atk < Formula
  desc "GNOME accessibility toolkit"
  homepage "https://library.gnome.org/devel/atk/"
  url "https://download.gnome.org/sources/atk/2.36/atk-2.36.0.tar.xz"
  sha256 "fb76247e369402be23f1f5c65d38a9639c1164d934e40f6a9cf3c9e96b652788"

  bottle do
    cellar :any
    sha256 "637e8455e933bb0b3d8d89f17764f9fb9f36304cfa1f731cf0bcad2508c41de8" => :catalina
    sha256 "68eacf007054ab993285f074370f212d28ea0ddbb1a8b834e730af1f54b82d1b" => :mojave
    sha256 "5e9e555d713f3454e2411ba51a89b8094770d8bdf40323e3b879a3c543b240e8" => :high_sierra
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

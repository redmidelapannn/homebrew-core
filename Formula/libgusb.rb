class Libgusb < Formula
  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.4.tar.xz"
  sha256 "581fd24e12496654b9b2a0732f810b554dfd9212516c18c23586c0cd0b382e04"

  bottle do
    sha256 "d9f9e605871defe1f2e16ae5019133d32a130050aadbc6b6e84b30366f2a67f5" => :catalina
    sha256 "06ce709c304a791aef5efc44e6cf15daa255394bf75ac5eb652a73ca8e7d886e" => :mojave
    sha256 "5f1e8593d60b45e1ff7826c5d1497a20b9d7c3f0f06cf97e0383dd4c34a1c719" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libusb"

  # The original usb.ids file can be found at http://www.linux-usb.org/usb.ids
  # It is updated over time and its checksum changes, we maintain a copy
  resource "usb.ids" do
    url "https://github.com/Homebrew/formula-patches/raw/7974b33541d9c284ebb98bdb04075e9ce462d0bd/libgusb/usb.ids"
    sha256 "1cdcceedf955feb8e3df72f41cb70e65691f979c5294127f040371756e617395"
  end

  def install
    (share/"hwdata/").install resource("usb.ids")
    inreplace "contrib/generate-version-script.py", "#!/usr/bin/python3", "#!/usr/bin/env python3"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", "-Dusb_ids=#{share}/hwdata/usb.ids", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gusbcmd", "-h"
    (testpath/"test.c").write <<~EOS
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libusb = Formula["libusb"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{libusb.opt_include}/libusb-1.0
      -I#{include}/gusb-1
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libusb.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lusb-1.0
      -lgusb
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

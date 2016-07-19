class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "http://www.gtkmm.org"
  url "https://download.gnome.org/sources/atkmm/2.24/atkmm-2.24.2.tar.xz"
  sha256 "ff95385759e2af23828d4056356f25376cfabc41e690ac1df055371537e458bd"

  bottle do
    cellar :any
    revision 1
    sha256 "8a95256cf7d34579fd2abda8acd0853d36b84d9f10f11526237a871f14c7ed1b" => :el_capitan
    sha256 "5b9d1146fef6d50a039bdef51454c1acb33255e03d74d5c6c72fed6d53d9ec7f" => :yosemite
    sha256 "5eac44f0508a822ca85c1384dd1c6a56111e195cf7314fb7f5a468063f4d31e8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glibmm"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    EOS
    atk = Formula["atk"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/atkmm-1.6
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -L#{atk.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -latk-1.0
      -latkmm-1.6
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

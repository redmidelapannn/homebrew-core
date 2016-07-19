class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "http://libxmlplusplus.sourceforge.net"
  url "https://download.gnome.org/sources/libxml++/2.40/libxml++-2.40.1.tar.xz"
  sha256 "4ad4abdd3258874f61c2e2a41d08e9930677976d303653cd1670d3e9f35463e9"

  bottle do
    cellar :any
    revision 1
    sha256 "02e0243895e30318e6ea3ee8991aea690be25f46aec4828fedd78435b43e74d8" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  # LibXML++ can't compile agains the version of LibXML shipped with Leopard
  depends_on "libxml2" if MacOS.version <= :leopard

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "http://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/libxml++-2.6
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libxml++-2.6/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
      -lxml++-2.6
      -lxml2
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

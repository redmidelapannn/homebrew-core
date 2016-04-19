class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "http://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.48/glibmm-2.48.1.tar.xz"
  sha256 "dc225f7d2f466479766332483ea78f82dc349d59399d30c00de50e5073157cdf"

  bottle do
    cellar :any
    sha256 "97665df5c1f359e7453aaebbf7c5a8a1d1933f39ede72f2bbfd3fbe090c3d3c7" => :el_capitan
    sha256 "9c819dfd283f59f068f3e7061bfe5671543ea1ce3dfc1be7c4f0a232f2704581" => :yosemite
    sha256 "c70e7a02f42d0c63fbd85b16baf981d9833c78299c01804bf5aacae8f71784cf" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsigc++"
  depends_on "glib"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libsigcxx = Formula["libsigc++"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/glibmm-2.4
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/glibmm-2.4/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
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

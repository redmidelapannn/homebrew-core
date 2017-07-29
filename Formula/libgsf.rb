class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.41.tar.xz"
  sha256 "150b98586a1021d5c49b3d4d065d0aa3e3674ae31db131af5372499d2d3f08d3"

  bottle do
    rebuild 1
    sha256 "e703d45eb78d13a425403d3578582f2854d504ff53cc973573051221111312d8" => :sierra
    sha256 "d710a808738285d99d77978dc0ad8e89a637d397e1ecfc4867be4966dc99acef" => :el_capitan
    sha256 "773cb82eafa2fc622675ee23b85c229b11ee7ee9306ecded12ff13590ac5111d" => :yosemite
  end

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gdk-pixbuf" => :optional

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<-EOS.undent
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end

class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.46.tar.xz"
  sha256 "ea36959b1421fc8e72caa222f30ec3234d0ed95990e2bf28943a85f33eadad2d"
  revision 1

  bottle do
    rebuild 1
    sha256 "230fb32d692803fee68cd004d3e21d712c9a2bc157f0d2253e54b49971dac33a" => :catalina
    sha256 "09223be958c8176be32e101e3f5b371d33a150b2b73d241d5dddb18a25bdec06" => :mojave
    sha256 "286251c9bc6436ca4446ec9e458d4728c46fb7d168d720ecbb3f02b3329a7844" => :high_sierra
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
  uses_from_macos "libxml2"

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
    (testpath/"test.c").write <<~EOS
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

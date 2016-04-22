class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "http://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.34/gdk-pixbuf-2.34.0.tar.xz"
  sha256 "d55e5b383ee219bd0e23bf6ed4427d56a7db5379729a6e3e0a0e0eba9a8d8879"

  bottle do
    sha256 "af087dc1b3752e0fa37a1a359c2f2227481c497fe43cd54b0e08b8a7e2581a4e" => :el_capitan
    sha256 "a102ee9a0b9eea7dba6e7554a5c8d4ea3ccf7d93195aff292ea443055f69753e" => :yosemite
    sha256 "d0b38d5bc5f9b53ed4fa2815b1b2882afd2af55971200f736ecb32c67bb8cf40" => :mavericks
  end

  option :universal
  option "with-relocations", "Build with relocation support for bundles"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "gobject-introspection"

  # 'loaders.cache' must be writable by other packages
  skip_clean "lib/gdk-pixbuf-2.0"

  def install
    ENV.universal_binary if build.universal?
    ENV.append_to_cflags "-DGDK_PIXBUF_LIBDIR=\\\"#{HOMEBREW_PREFIX}/lib\\\""
    args = ["--disable-dependency-tracking",
            "--disable-maintainer-mode",
            "--enable-debug=no",
            "--prefix=#{prefix}",
            "--enable-introspection=yes",
            "--disable-Bsymbolic",
            "--enable-static",
            "--without-gdiplus",]

    args << "--enable-relocations" if build.with?("relocations")

    system "./configure", *args
    system "make"
    system "make", "install"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/"pkgconfig/gdk-pixbuf-2.0.pc" do |s|
      libv = s.get_make_var "gdk_pixbuf_binary_version"
      s.change_make_var! "gdk_pixbuf_binarydir",
        HOMEBREW_PREFIX/"lib/gdk-pixbuf-2.0"/libv
    end

    # Remove the cache. We will regenerate it in post_install
    (lib/"gdk-pixbuf-2.0/2.10.0/loaders.cache").unlink
  end

  def post_install
    # Change the version directory below with any future update
    if build.with?("relocations")
      ENV["GDK_PIXBUF_MODULE_FILE"]="#{lib}/gdk-pixbuf-2.0/2.10.0/loaders.cache"
      ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    end
    system "#{bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  def caveats; <<-EOS.undent
    Programs that require this module need to set the environment variable
      export GDK_PIXBUF_MODULE_FILE="#{lib}/gdk-pixbuf-2.0/2.10.0/loaders.cache"
      export GDK_PIXBUF_MODULEDIR="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    If you need to manually update the query loader cache, set these variables then run
      #{bin}/gdk-pixbuf-query-loaders --update-cache
    EOS
  end if build.with?("relocations")

  test do
    system bin/"gdk-pixbuf-csource", test_fixtures("test.png")
  end
end

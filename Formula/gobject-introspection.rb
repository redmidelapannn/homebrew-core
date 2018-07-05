class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.56/gobject-introspection-1.56.1.tar.xz"
  sha256 "5b2875ccff99ff7baab63a34b67f8c920def240e178ff50add809e267d9ea24b"

  bottle do
    rebuild 1
    sha256 "920d5f64b96cb7bd343073496cfe4d4b29cd1edb6d482f1959249e245e82605d" => :high_sierra
    sha256 "52f12ba711c1a65bdb6cc1fda9830f63da96614db09f1ac8b85f764d26138444" => :sierra
  end

  depends_on "pkg-config"
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python@2"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-python=#{Formula["python@2"].opt_bin}/python2"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end

class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.56/gobject-introspection-1.56.1.tar.xz"
  sha256 "5b2875ccff99ff7baab63a34b67f8c920def240e178ff50add809e267d9ea24b"

  bottle do
    rebuild 1
    sha256 "3dacb70abcb5ed31e0f3ffb75b36b1729f691abf2af2dbd605f580d8320c4ae0" => :high_sierra
    sha256 "a9ede8ae39790b429f07ce9669259e99d57a36014bf6900160b43919a79a6c21" => :sierra
    sha256 "88c634f43a679346e06638f0bc1ca06d241b0c1d2d25eaa367dfb2d8d2c03e66" => :el_capitan
  end

  depends_on "pkg-config"
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python"

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
                          "--with-python=#{Formula["python"].opt_bin}/python3"
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

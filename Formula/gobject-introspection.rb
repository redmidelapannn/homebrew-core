class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.48/gobject-introspection-1.48.0.tar.xz"
  sha256 "fa275aaccdbfc91ec0bc9a6fd0562051acdba731e7d584b64a277fec60e75877"

  bottle do
    sha256 "55e8bd144ec3e913155c42a6a32c2357ee35eac5436cf153d52421422bda5a6a" => :el_capitan
    sha256 "d96ed54bbe0353abf41a233f7786ebd28d4afbc13c5b143360db1cb65ae25f7c" => :yosemite
    sha256 "7a178aced74e2931b4fcf97302ef2e9c97aaf587fb2ed9346a5061d1b6e21a10" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :run
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
    ENV.universal_binary if build.universal?
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "configure" do |s|
      s.change_make_var! "GOBJECT_INTROSPECTION_LIBDIR", "#{HOMEBREW_PREFIX}/lib"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=#{HOMEBREW_PREFIX}/bin/python"
    system "make"
    system "make", "install"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert (testpath/"Tut-0.1.typelib").exist?
  end
end

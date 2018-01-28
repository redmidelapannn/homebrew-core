class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.54/gobject-introspection-1.54.1.tar.xz"
  sha256 "b88ded5e5f064ab58a93aadecd6d58db2ec9d970648534c63807d4f9a7bb877e"

  bottle do
    rebuild 1
    sha256 "5c35c147ce19ea0d830f82a4b8032007206a9e75bc975aa9094c85aac90c78d6" => :high_sierra
    sha256 "c2ede58010218bdb9329c778567c121a9141ceec8958c4869a3df80d11fb0400" => :sierra
    sha256 "1001774b1ec4f593bc7be37ea47578b19859ea5bfd9f21fa2a1191c095a3feea" => :el_capitan
  end

  depends_on "pkg-config" => :run
  depends_on "glib"
  depends_on "cairo"
  depends_on "libffi"
  depends_on "python" if MacOS.version <= :mavericks

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

    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin" if MacOS.version <= :mavericks
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=python"
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

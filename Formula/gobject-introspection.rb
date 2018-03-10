class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://live.gnome.org/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.54/gobject-introspection-1.54.1.tar.xz"
  sha256 "b88ded5e5f064ab58a93aadecd6d58db2ec9d970648534c63807d4f9a7bb877e"
  revision 1

  bottle do
    rebuild 1
    sha256 "c9cc5d2b82b30d495851ebcfe0abf8a0c53dd10e76d0d14f617d35af9b594db2" => :high_sierra
    sha256 "9427de4194958e11b910b1047a5e1becf79e93f53b6deffceb67c06f0352bf6f" => :sierra
    sha256 "a7f66a6e7792efcf26b7b3707ad17dbe64ddae665fb918502d4a25a7e452410e" => :el_capitan
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

    python = if MacOS.version >= :yosemite
      "/usr/bin/python2.7"
    else
      Formula["python"].opt_bin/"python3"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-python=#{python}"
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

class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.64/gobject-introspection-1.64.1.tar.xz"
  sha256 "80beae6728c134521926affff9b2e97125749b38d38744dc901f4010ee3e7fa7"

  bottle do
    sha256 "76967df65c854712449224b7d5eed20ed6467ef6eed2267f260fff0f8d9fc0d3" => :catalina
    sha256 "efbaf51ca8e1862ff4d201d20f4f6207b58e3cfa56ef2a380cfa6908262571fa" => :mojave
    sha256 "2c952b43ecd86ccce56593947627b06a71947145aa5a2c712df6226220cc8fe0" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python@3.8"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  def install
    Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    args = %W[
      --prefix=#{prefix}
      -Dpython=#{Formula["python@3.8"].opt_bin}/python3
    ]

    mkdir "build" do
      system "meson", *args, ".."
      Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end

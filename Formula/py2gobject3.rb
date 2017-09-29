class Py2gobject3 < Formula
  desc "GNOME Python2 bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.26/pygobject-3.26.0.tar.xz"
  sha256 "7411acd600c8cb6f00d2125afa23303f2104e59b83e0a4963288dbecc3b029fa"

  bottle do
    cellar :any
    sha256 "09b704e926cd2514c7a7c9393cc305c3bab08d46fedd3a12b5736c9f54bd380c" => :high_sierra
    sha256 "f68518e5cd385e293ea2b1a214799cb8f3e6b3b82a22d135e1e9c4f82860f5eb" => :sierra
    sha256 "6c697c72740eb9ebc885e1b82325235c3798cb69cd4e4b2776ffbddbdaf37f09" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "py2cairo"
  depends_on "gobject-introspection"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    # ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system "python", "test.py"
  end
end

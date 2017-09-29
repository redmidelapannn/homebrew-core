class Py3gobject3 < Formula
  desc "GNOME Python3 bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.26/pygobject-3.26.0.tar.xz"
  sha256 "7411acd600c8cb6f00d2125afa23303f2104e59b83e0a4963288dbecc3b029fa"

  bottle do
    cellar :any
    sha256 "a7b05161ee1e9a9d7d34cdbbf2033e8ffaf6b47d193186efc45f4eef7ed372a5" => :high_sierra
    sha256 "2abc3ff53800225cefb8e04bf48f95aee0c5c30c2e14e4b8c71b3c9fd871e4c6" => :sierra
    sha256 "c482e9b07b0fa956b987525c58881532f5249bfb65c945840e10861d601e1de8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3
  depends_on "py3cairo"
  depends_on "gobject-introspection"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    # ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system "python3", "test.py"
  end
end

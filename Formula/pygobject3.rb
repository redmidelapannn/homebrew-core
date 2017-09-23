class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.26/pygobject-3.26.0.tar.xz"
  sha256 "7411acd600c8cb6f00d2125afa23303f2104e59b83e0a4963288dbecc3b029fa"
  revision 1

  bottle do
    cellar :any
    sha256 "9744013c0950c18f5a6ba4b78983626e2471f41d5a59e1b17e33fb582351e245" => :high_sierra
    sha256 "fd9a3c771a34ac01713b0b247db524873cf214ac2253f71ab6c8ff112c4998db" => :sierra
    sha256 "47a359c0b814c91f2cbc13d6d8d487b11535e1db7bb14944f90c85d49e67b760" => :el_capitan
  end

  option "without-python", "Build without python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3 => :optional
  depends_on "py2cairo" if build.with? "python"
  depends_on "py3cairo" if build.with? "python3"
  depends_on "gobject-introspection"

  def install
    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}", "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
    import gi
    assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, pyversion|
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end

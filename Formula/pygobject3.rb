class Pygobject3 < Formula
  desc "GLib/GObject/GIO Python bindings for Python 3"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.20/pygobject-3.20.0.tar.xz"
  sha256 "31ab4701f40490082aa98af537ccddba889577abe66d242582f28577e8807f46"

  bottle do
    sha256 "df57bc1ca4663ea8e4183b6c30f3f6d8f122cac613458e305ed7f5ed4d658951" => :el_capitan
    sha256 "01758d10fbf288896b2cba41ddafb7333e0d695a96e33e396814bda4ddca392c" => :yosemite
    sha256 "527fd4758a5285bc024f0657b9abd992b3f8d3f11282bff378945399a169f576" => :mavericks
  end

  option :universal
  option "without-python", "Build without python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on :python3 => :optional
  depends_on "py2cairo" if build.with? "python"
  depends_on "py3cairo" if build.with? "python3"
  depends_on "gobject-introspection"

  def install
    ENV.universal_binary if build.universal?

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
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end

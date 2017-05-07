class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.24/pygobject-3.24.1.tar.xz"
  sha256 "a628a95aa0909e13fb08230b1b98fc48adef10b220932f76d62f6821b3fdbffd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7d78fd9e23e5d316a4463dd6416b745b2778268245e2ee3de94810e88ef90ec2" => :sierra
    sha256 "e3b2143683aba47c75f80989afa23e3fa5efbeff5b825371544c990010e5b384" => :el_capitan
    sha256 "b53ba53dd7fa1198675dfdaf79bb17b1c9fdb4e0a0ac79855548ffbb9d277b90" => :yosemite
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

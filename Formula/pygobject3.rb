class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.28/pygobject-3.28.3.tar.xz"
  sha256 "3dd3e21015d06e00482ea665fc1733b77e754a6ab656a5db5d7f7bfaf31ad0b0"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "cac4c4cc9b35f896d5be8f89ae4e880532b90dbc7192187dc83d88e8d476a900" => :high_sierra
    sha256 "754dcf61d8c9962c288b37e9dde708e2a4bab4dc40eafebc53bf5272fa99f163" => :sierra
    sha256 "7d64314eb5aa4c0ec243c0bc929123aad334ca23ccbf1ea7fa9ea1ec6c712e44" => :el_capitan
  end

  option "without-python", "Build without python3 support"
  option "with-python@2", "Build with python2 support"

  depends_on "pkg-config" => :build
  depends_on "libffi" => :optional
  depends_on "glib"
  depends_on "python@2" => :optional
  depends_on "python" => :recommended
  depends_on "py2cairo" if build.with? "python@2"
  depends_on "py3cairo" if build.with? "python"
  depends_on "gobject-introspection"

  def install
    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, pyversion|
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end

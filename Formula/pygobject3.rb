class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.22/pygobject-3.22.0.tar.xz"
  sha256 "08b29cfb08efc80f7a8630a2734dec65a99c1b59f1e5771c671d2e4ed8a5cbe7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "918eda8fa3eb9dbff428e764104b6814197563d5fa51c1f339f8bb340924764e" => :sierra
    sha256 "a876d8b1ca3ea84254a214c1a4af359d76ac4125ac3cbba140f4561bf2a296f3" => :el_capitan
    sha256 "29ca93888a172418ae7cbad4ada5067cb132414891d61fcc57c2dd315f3de405" => :yosemite
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
    Language::Python.each_python(build) do |python, _version|
      system python, "test.py"
    end
  end
end

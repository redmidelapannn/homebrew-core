class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.22/pygobject-3.22.0.tar.xz"
  sha256 "08b29cfb08efc80f7a8630a2734dec65a99c1b59f1e5771c671d2e4ed8a5cbe7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e73ad7315536c037aa6e26a75f80d6ccefafb5eca5a73e9f115bf46b064064d8" => :sierra
    sha256 "271dac55f73de48eeb407136de67c5a810f45f137dbecba6d335ca14f76f9c22" => :el_capitan
    sha256 "4ccc94e33fe1887951561a14dbdd44e57dbb2c2b52165a30f43bb5c06307e8f6" => :yosemite
  end

  option :universal
  option "without-python", "Build without python2 support"
  option "without-python3", "Build without python3 support"

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

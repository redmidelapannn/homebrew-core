class Pygobject3 < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.36/pygobject-3.36.0.tar.xz"
  sha256 "8683d2dfb5baa9e501a9a64eeba5c2c1117eadb781ab1cd7a9d255834af6daef"
  revision 1

  bottle do
    cellar :any
    sha256 "0e1fb19862c7b6f445eb176868d9bcc7a91e000faa53968e7645b6d725169a42" => :catalina
    sha256 "c55064a6be30c1fc84ad7e7ab505f26bfbd2f13bfb62897c0b085ab4a000e330" => :mojave
    sha256 "129acc2381929c53bd56991a2028f0f89cfe8484bf2942d231cf40c2c4d02471" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gobject-introspection"
  depends_on "py3cairo"
  depends_on "python"

  def install
    mkdir "buildpy3" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpycairo=true",
                      "-Dpython=python3",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      gi.require_version("GLib", "2.0")
      assert("__init__" in gi.__file__)
      from gi.repository import GLib
      assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))
    EOS

    pyversion = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
    system "python3", "test.py"
  end
end

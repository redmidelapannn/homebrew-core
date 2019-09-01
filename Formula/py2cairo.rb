class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.1/pycairo-1.18.1.tar.gz"
  sha256 "70172e58b6bad7572a3518c26729b074acdde15e6fee6cbab6d3528ad552b786"

  bottle do
    cellar :any
    rebuild 1
    sha256 "19a35efc3cdccdcedc76ce4e06ec5cdbbd72cc9058964be148d5ac6c069bb218" => :mojave
    sha256 "b1390ef17f1881feff493e4f292c7f8432528144fc107dcc3fe293f14ff13895" => :high_sierra
    sha256 "d6553bccd36c96e1eba4ad631ce1372012eea19e21b292fceef3fae2a473dd0e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end

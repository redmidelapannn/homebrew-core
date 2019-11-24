class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz"
  sha256 "dcb853fd020729516e8828ad364084e752327d4cff8505d20b13504b32b16531"
  revision 1

  bottle do
    cellar :any
    sha256 "e85808a42429c820e7f32e76edee4434c74c311fbbab07be43b5ba09d5ef6c29" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end

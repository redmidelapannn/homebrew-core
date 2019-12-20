class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz"
  sha256 "dcb853fd020729516e8828ad364084e752327d4cff8505d20b13504b32b16531"

  bottle do
    cellar :any
    sha256 "5c3f6cfbff7660648aa4b5190e432bf2c574e11655a61f9262874594d3edc47d" => :mojave
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

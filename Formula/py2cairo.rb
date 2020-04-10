class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz"
  sha256 "dcb853fd020729516e8828ad364084e752327d4cff8505d20b13504b32b16531"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "383bf15582557fce7a1cd18dd7dfeccf68c6f0ecffb30810d6c41231bf8672c6" => :catalina
    sha256 "dbd078afb9d89c54b7268c1b8573865103a253e13158e3f1e3ff9123ff47b0be" => :mojave
    sha256 "576b1a7a3d402872f9fce086f395f2716b0faa35e55757106e4a5d1c43558c90" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :macos # Due to Python 2

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end

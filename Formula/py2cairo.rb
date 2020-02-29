class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.19.1/pycairo-1.19.1.tar.gz"
  sha256 "2c143183280feb67f5beb4e543fd49990c28e7df427301ede04fc550d3562e84"

  bottle do
    cellar :any
    sha256 "7d384af8a2319f53d46cbf8a062e9b0e68af8fc05352a64dd1f920f60d5af5b4" => :catalina
    sha256 "4ddca8c8b065a65a9e756546ffe2ac087fc43d45a6437bca40e9c5912736ec66" => :mojave
    sha256 "8d6ffd15ca64364d42ba93b3d892859aed6c06e2889b793841b069cf90eb58b9" => :high_sierra
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

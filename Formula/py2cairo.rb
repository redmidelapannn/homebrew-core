class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.3/pycairo-1.16.3.tar.gz"
  sha256 "5bb321e5d4f8b3a51f56fc6a35c143f1b72ce0d748b43d8b623596e8215f01f7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "11cc47ea444d2b700fc202f30344addcd4d0732ce90979a90c09d3142003e3aa" => :high_sierra
    sha256 "cbdb5fa0f901d4a5ce083c9e4c6d972bc0150422778292572f29ee699c6c874a" => :sierra
    sha256 "7dcde205980101c265e74c475d97cd952b6b1da13ef9d882f42795e7f99ae5fe" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python@2"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end

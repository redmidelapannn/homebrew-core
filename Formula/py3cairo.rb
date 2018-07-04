class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.17.0/pycairo-1.17.0.tar.gz"
  sha256 "cdd4d1d357325dec3a21720b85d273408ef83da5f15c184f2eff3212ff236b9f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "df7278e2a222ebec21d13af5d54b30c2affd8452b46b3d1d7b78e21aecd88472" => :high_sierra
    sha256 "0127a8d64389ec274354b7a5ea1bcb2692da77426daf560d5122f83671f45786" => :sierra
    sha256 "25147d63de911163bb940a26a3801cae0ead4f730571906dda81ed55ecd6a270" => :el_capitan
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

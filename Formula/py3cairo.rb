class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://cairographics.org/releases/pycairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/pycairo-1.10.0.tar.bz2"
  sha256 "9aa4078e7eb5be583aeabbe8d87172797717f95e8c4338f0d4a17b683a7253be"
  revision 2

  bottle do
    revision 1
    sha256 "6691035852e3fda338ec373654beea0f8b49ffc4cf67aa47657c85463ef8b793" => :el_capitan
    sha256 "08bcc78a5bf4d846ec94125fac7fccbc627f8065c32e7631d14491d464c3fa96" => :yosemite
    sha256 "e637e829b03f30da41b941bd12ff8bb4c0c0ac39f7dca6d6128162b47b3de5ae" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python3

  def install
    ENV["PYTHON"] = "python3"
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end

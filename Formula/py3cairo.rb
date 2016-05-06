class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://cairographics.org/releases/pycairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/pycairo-1.10.0.tar.bz2"
  sha256 "9aa4078e7eb5be583aeabbe8d87172797717f95e8c4338f0d4a17b683a7253be"
  revision 2

  bottle do
    revision 1
    sha256 "17cd8e4b71cc0de6388619da1defc0320bd55205894374ec305da13ab16dc002" => :el_capitan
    sha256 "03a9926a934d6537f7c60f89fbf920f97ad210c7af4b7b23f8e2b753f14fc1f8" => :yosemite
    sha256 "66f21c15393b5db2b27da27b70d7cfec0c329733da4023c71a393383726f686b" => :mavericks
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

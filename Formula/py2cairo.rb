class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://cairographics.org/releases/py2cairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/py2cairo-1.10.0.tar.bz2"
  sha256 "d30439f06c2ec1a39e27464c6c828b6eface3b22ee17b2de05dc409e429a7431"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "568bc91beaf3230495d0f397b1e489482dc1dffc5f85a13eb97a84c9dbe6e727" => :sierra
    sha256 "f78c1d27fbf75ab02d7d1dc90384d3356ebc33375a9daef83cda62e53f1d318d" => :el_capitan
    sha256 "e7f3f5f6d8a4fc640f2d4d0b6ddb217d5fff45ee28b5180f77037130cfd50a88" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.refurbish_args

    # disable waf's python extension mode because it explicitly links libpython
    # https://code.google.com/p/waf/issues/detail?id=1531
    inreplace "src/wscript", "pyext", ""
    ENV["LINKFLAGS"] = "-undefined dynamic_lookup"
    ENV.append_to_cflags `python-config --includes`

    # Python extensions default to universal but cairo may not be universal
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"

    module_dir = lib/"python2.7/site-packages/cairo"
    mv module_dir/"lib_cairo.dylib", module_dir/"_cairo.so"
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end

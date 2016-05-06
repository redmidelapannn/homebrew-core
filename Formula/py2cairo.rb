class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://cairographics.org/releases/py2cairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/py2cairo-1.10.0.tar.bz2"
  sha256 "d30439f06c2ec1a39e27464c6c828b6eface3b22ee17b2de05dc409e429a7431"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "4e863f5ee158a4c161118aa92f32ed27871d50fbcdfaf919a0e576e5e88c2bcc" => :el_capitan
    sha256 "f5d6c27177f4fa9c3306f597d6c45e9a9aa73f52afa9a594fc5e8bc76b495e9b" => :yosemite
    sha256 "7dcef66c7b224bc99f36dbe79ce516ac79e19b89e907f913256b14a6fad70147" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  fails_with :llvm do
    build 2336
    cause "The build script will set -march=native which llvm can't accept"
  end

  def install
    ENV.refurbish_args

    # disable waf's python extension mode because it explicitly links libpython
    # https://code.google.com/p/waf/issues/detail?id=1531
    inreplace "src/wscript", "pyext", ""
    ENV["LINKFLAGS"] = "-undefined dynamic_lookup"
    ENV.append_to_cflags `python-config --includes`

    # Python extensions default to universal but cairo may not be universal
    ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}" unless build.universal?

    system "./waf", "configure", "--prefix=#{prefix}", "--nopyc", "--nopyo"
    system "./waf", "install"

    module_dir = lib/"python2.7/site-packages/cairo"
    mv module_dir/"lib_cairo.dylib", module_dir/"_cairo.so"
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end

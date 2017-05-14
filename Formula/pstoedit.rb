class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.70/pstoedit-3.70.tar.gz"
  sha256 "06b86113f7847cbcfd4e0623921a8763143bbcaef9f9098e6def650d1ff8138c"
  revision 2

  bottle do
    rebuild 1
    sha256 "197957ed5680c78abd30540bcad6fc980c7baa6f17ba91e168b324ccca5898d5" => :sierra
    sha256 "84519d9fd8c395fbcc337245f66149cc5a98ffc66873384bb3d75dd221a50654" => :el_capitan
    sha256 "eaa0f094299333270141c637d648a0450d13224e7be748e6e5d1d5ac93b2b811" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "plotutils"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "xz" if MacOS.version < :mavericks

  # Fix for pstoedit search for plugins, thereby restoring formats that
  # worked in 3.62 but now don't in 3.70, including PIC, DXF, FIG, and
  # many others.
  #
  # This patch has been submitted upstream; see:
  # https://sourceforge.net/p/pstoedit/bugs/19/
  #
  # Taken from:
  # https://build.opensuse.org/package/view_file/openSUSE:Factory/pstoedit/pstoedit-pkglibdir.patch?expand=1
  #
  # This patch changes the behavior of "make install" so that:
  # * If common/plugindir is defined, it checks only that directory.
  # * It swaps the check order: First checks whether PSTOEDITLIBDIR exists. If
  #   it exists, it skips blind attempts to find plugins.
  # As PSTOEDITLIBDIR is always defined by makefile, the blind fallback will
  # be attempted only in obscure environments.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fa1823b/pstoedit/3.70.patch"
    sha256 "9af1bbc9db97f5d5dc92816e5c5fdd5f98904f64d1ab0dd6fcdcde1fd8606ce6"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "pdf", test_fixtures("test.ps"), "test.pdf"
    assert File.exist?("test.pdf")
  end
end

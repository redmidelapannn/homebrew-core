class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.9.tar.bz2"
  sha256 "7958985393eca33b2db173090af78a46e42a7daefe7f6eaa7efa4ba261fa46f3"
  revision 1
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    rebuild 2
    sha256 "32e9b3905f9a07284d40041c22e57da79e4efd99a3ae13cf5a1a67a142d61812" => :mojave
    sha256 "58f5147f2c3ea98d4f3cdc1bdcf42b4241c5676fae7c3756532e8787ac9fbcbf" => :high_sierra
    sha256 "f9c6a93764da233a7283978ee5d8bbb26aa4f9d60d352f503c365cc587b3150f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk-mac-integration"
  depends_on "jpeg"
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv@3"
  depends_on "openjpeg"

  fails_with :clang # no OpenMP support

  needs :cxx11

  def install
    ENV.cxx11

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    system "./autogen.sh", "--prefix=#{prefix}", "--enable-openmp"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end

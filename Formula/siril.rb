class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.3.tar.bz2"
  sha256 "f6ca57b668441505010673b153f85fa23efdf41fe74ee7ecb5a4926a572acfa3"
  revision 1
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    rebuild 1
    sha256 "2ae47a79a2e32f80e65d12b59bfe2c9706845d71c7e157ef9f6a33db0f50854b" => :high_sierra
    sha256 "42b034c18d6be45bc9aadef6e2a4934c3db646ee5dde4379e3ebb12fc490bafc" => :sierra
    sha256 "91537400ecdb5ef8d455ee08edf92d8a82d7cbb346839f230e6d12a0c16bd49a" => :el_capitan
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
  depends_on "libconfig"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  fails_with :clang # no OpenMP support

  needs :cxx11

  def install
    ENV.cxx11

    system "./autogen.sh", "--prefix=#{prefix}", "--enable-openmp"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end

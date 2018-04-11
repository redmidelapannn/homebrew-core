class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.8.3.tar.bz2"
  sha256 "f6ca57b668441505010673b153f85fa23efdf41fe74ee7ecb5a4926a572acfa3"
  revision 2
  head "https://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "5e5eb66051255a0ae4b3b30bdc942d1c3e5c70dd35ae5d47574bf23b42d824de" => :high_sierra
    sha256 "9ee9e8b9c2e0a03b53ffb7f2bb739678768646634dc73c0839b6daab30cc7bda" => :sierra
    sha256 "daa6c7a1d0f188c5a50489fc0ce54bca110b0a1d5c31db71a4e28365dfb917f2" => :el_capitan
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

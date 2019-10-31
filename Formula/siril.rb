class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.11.tar.bz2"
  sha256 "d30e40eed82af9d8e4392c5d888047b1a87a1705514444da3f319845b0652349"
  revision 4
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "d404bd57c8e4ee5b21cdf892afcd7515156ee0fb6ff0278c59ac58384bd41789" => :catalina
    sha256 "54fcc8754f8dbf4ae716ce38079b127cf6128f0edb97dc32b84cbfff0c5a9218" => :mojave
    sha256 "4b209871a587f79014ca96cc1a3fd37fc461538f7a57843650b71b6d3c80acdf" => :high_sierra
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
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk-mac-integration"
  depends_on "jpeg"
  depends_on "libconfig"
  depends_on "libomp"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  def install
    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -Xpreprocessor -fopenmp -lomp"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end

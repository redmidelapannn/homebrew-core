class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-0.9.12.tar.bz2"
  sha256 "9fb7f8a10630ea028137e8f213727519ae9916ea1d88cd8d0cc87f336d8d53b1"
  revision 2
  head "https://gitlab.com/free-astro/siril.git"

  bottle do
    sha256 "0f62476807116700ae7e4dd68ff3d573fb92d5b8623548e5654305bd96382367" => :catalina
    sha256 "1c870d4af4fc1d31b84a486bd8e94322bf1c66ad6a0355e69a963e08f159e3d7" => :mojave
    sha256 "e7680e0ce5595f57ea3f183967f9a0e865bd3104c1cebff502b25f4c6bb16f5e" => :high_sierra
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

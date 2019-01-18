class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://free-astro.org/index.php/Siril"
  url "https://free-astro.org/download/siril-0.9.9.tar.bz2"
  sha256 "7958985393eca33b2db173090af78a46e42a7daefe7f6eaa7efa4ba261fa46f3"
  revision 4
  head "http://free-astro.org/svn/siril/", :using => :svn

  bottle do
    sha256 "18b06e355a9821c0be8e8a4e46656860ba76471bca5e2240e1e0d32bd380d62d" => :mojave
    sha256 "925e4c4161cdeb26cf8ec1864cde50c76aac924b58b2fdd78a6ad0c34d6deac4" => :high_sierra
    sha256 "c03edaade1b17238dc49d359b6aac1b8ad506fd261e4d9c3386d5018a889e017" => :sierra
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
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"

  # Upstream fix for compilation with OpenCV 4
  # Remove in next version
  patch do
    url "https://gitlab.com/free-astro/siril/commit/c23c2cc829b2ad9444ccefeb865f7e1b3d49c282.diff"
    sha256 "22e179e832c7f6a28d5f2bfb3953be477b15450df41ceeb353b77376bec7e048"
  end

  needs :cxx11

  def install
    ENV.cxx11

    # siril uses pkg-config but it has wrong include paths for several
    # headers. Work around that by letting it find all includes.
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include"

    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/siril", "-v"
  end
end

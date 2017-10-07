class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "http://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "760f1d383ff9e057c47bbeb0c6090bf1ad1beb1fc72c9581ccd18e94850e490e" => :high_sierra
    sha256 "bd4fb747f4aeaa6fd6f1ea1aa0fe5f24f973d976f80de54e9f7e39215dc349e8" => :sierra
    sha256 "1304ed040007dd8fdf4cb19825ebb24cc3135d0ddbad3042b0328073fc72da29" => :el_capitan
  end
  
  head do
    url "https://github.com/openslide/openslide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libxml2"
  depends_on "libtiff"
  depends_on "glib"
  depends_on "openjpeg"
  depends_on "cairo"
  depends_on "gdk-pixbuf"

  resource "svs" do
    url "http://openslide.cs.cmu.edu/download/openslide-testdata/Aperio/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end


  def install
    if build.head?
      system "autoreconf", "-i"
      system "./configure", "--without-makeinfo",
                            "--disable-static",
                            "--prefix=#{prefix}"
    else
      system "./configure", "--disable-dependency-tracking",
                            "--disable-static",
                            "--prefix=#{prefix}"
    end
    system "make", "install"
  end

  test do
    resource("svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end

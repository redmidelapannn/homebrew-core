class SpatialiteGui < Formula
  desc "GUI tool supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite_gui/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-gui-sources/spatialite_gui-1.7.1.tar.gz"
  sha256 "cb9cb1ede7f83a5fc5f52c83437e556ab9cb54d6ace3c545d31b317fd36f05e4"
  revision 5

  bottle do
    cellar :any
    rebuild 1
    sha256 "1f257369b21ffb4d7ddc3bcec4ed56f39cea45f5b36f8b2d5fb822c1e706ac00" => :catalina
    sha256 "082cb3dcf521c0ce6f76ee38cf39862def12df2bcada142d8916ee10f23d154d" => :mojave
    sha256 "ee40b2bde20fb250e738fbed8c1592526ca860be96f8e97d25c940211e140c89" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freexl"
  depends_on "geos"
  depends_on "libgaiagraphics"
  depends_on "libspatialite"
  depends_on "proj"
  depends_on "sqlite"
  depends_on "wxmac"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/spatialite-gui/1.7.1.patch"
    sha256 "37f71f3cb2b0b9649eb85a51296187b0adf2972c5a1d3ee0daf3082e2c35025e"
  end

  def install
    # Link flags for sqlite don't seem to get passed to make, which
    # causes builds to fatally error out on linking.
    # https://github.com/Homebrew/homebrew/issues/44003
    sqlite = Formula["sqlite"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include}"

    # Use Proj 6.0.0 compatibility headers
    # https://www.gaia-gis.it/fossil/spatialite_gui/tktview?name=8349866db6
    ENV.append_to_cflags "-DACCEPT_USE_OF_DEPRECATED_PROJ_API_H"

    # Add aui library; reported upstream multiple times:
    # https://groups.google.com/forum/#!searchin/spatialite-users/aui/spatialite-users/wnkjK9pde2E/hVCpcndUP_wJ
    inreplace "configure", "WX_LIBS=\"$(wx-config --libs)\"", "WX_LIBS=\"$(wx-config --libs std,aui)\""
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

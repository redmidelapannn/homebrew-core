class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 5

  bottle do
    cellar :any
    sha256 "6f6363d1d3044456bd7cfe0b38e0b119063602210d43e8bbbc708bc7818c6008" => :mojave
    sha256 "3c71cb02cd6af75ccd94ac0abae858ff03a259a9eb5b4aba9b517a1d7fdd91f3" => :high_sierra
    sha256 "737b28e31524c3eff4441f8bdb6b6c17020e290e6a5f9f34430bee165b3f56bd" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libgeotiff"
  depends_on "libpng"
  depends_on "libspatialite"
  depends_on "sqlite"

  def install
    # Ensure Homebrew SQLite libraries are found before the system SQLite
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

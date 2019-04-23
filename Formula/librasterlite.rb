class Librasterlite < Formula
  desc "Library to store and retrieve huge raster coverages"
  homepage "https://www.gaia-gis.it/fossil/librasterlite/index"
  url "https://www.gaia-gis.it/gaia-sins/librasterlite-sources/librasterlite-1.1g.tar.gz"
  sha256 "0a8dceb75f8dec2b7bd678266e0ffd5210d7c33e3d01b247e9e92fa730eebcb3"
  revision 6

  bottle do
    cellar :any
    sha256 "3ab5ee1e36e19dfdaa418e791e7f0b918d8d47e4a5acb460ea77904c9eb73723" => :mojave
    sha256 "b2a323504c2e322692b45b8b0d4c6532844ce8e8bc8d4e388e6511c9931d7b4e" => :high_sierra
    sha256 "d7cc306eaee86352df75f73621d75fe8e6855b6b0d1bc1644bd9fc178be44ca4" => :sierra
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

class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-4.3.0.tar.gz"
  sha256 "f739859bc04f38735591be2f75009b98a2359033675ae310dffc3114a17ccf89"
  revision 4

  bottle do
    cellar :any
    sha256 "88254c871b5423d04e7f7394ab278aa2ea55e290c2fd1ac36bb4da68a5532bb4" => :mojave
    sha256 "d27157c63d0a85b6c734097ffdc81c7f9f91035ad48d72eaecd963973a5922f7" => :high_sierra
    sha256 "29396d4183ede4946701aa3651b21c02ebdd3a5761fe3bfd8962067439db8af3" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv"
    # Ensure Homebrew SQLite is found before system SQLite.
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib}"
    ENV.append "CFLAGS", "-I#{sqlite.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end

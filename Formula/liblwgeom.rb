class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.5.2.tar.gz"
  sha256 "b6cb286c5016029d984f8c440947bf9178da72e1f6f840ed639270e1c451db5e"
  revision 2
  head "https://svn.osgeo.org/postgis/trunk/"

  bottle do
    cellar :any
    sha256 "1f618edc38b46b549f54f69fb7f23531d4fcc7986aff67f20cbc1171721a7681" => :mojave
    sha256 "5e44897cc62f2371c75ffeb85eb464ef28b4081b153871d4cef160185f0e980c" => :high_sierra
    sha256 "32ec843edd1274e2ba99eae11245496512155f057db27e852a2d2333168b0fe9" => :sierra
  end

  keg_only "conflicts with PostGIS, which also installs liblwgeom.dylib"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gpp" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "geos"
  depends_on "json-c"
  depends_on "proj"

  def install
    # See postgis.rb for comments about these settings
    ENV.deparallelize

    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    args = [
      "--disable-dependency-tracking",
      "--disable-nls",

      "--with-projdir=#{Formula["proj"].opt_prefix}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",

      # Disable extraneous support
      "--without-pgconfig",
      "--without-libiconv-prefix",
      "--without-libintl-prefix",
      "--without-raster", # this ensures gdal is not required
      "--without-topology",
    ]

    system "./autogen.sh"
    system "./configure", *args

    mkdir "stage"
    cd "liblwgeom" do
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <liblwgeom.h>

      int main(int argc, char* argv[])
      {
        printf("%s\\n", lwgeom_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["proj"].opt_include}",
                   "-L#{lib}", "-llwgeom", "-o", "test"
    system "./test"
  end
end

class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.4.3.tar.gz"
  sha256 "ea5374c5db6b645ba5628ddcb08f71d3b3d90a464d366b4e1d20d5a268bde4b9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "52f71c9248c842364adc14a44ed0bbbea5c0c37e1098d6b81d49c62d01e92dd6" => :high_sierra
    sha256 "61656a58f9180b47f416b651fb6798831b1961c90847cec790cca724b3dc995d" => :sierra
    sha256 "78304c10de70894d51a6e4cc78119b2e954587f080e7d6100b83eb1dc0b5418f" => :el_capitan
  end

  head do
    url "https://svn.osgeo.org/postgis/trunk/"
  end

  keg_only "conflicts with PostGIS, which also installs liblwgeom.dylib"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gpp" => :build

  depends_on "proj"
  depends_on "geos"
  depends_on "json-c"

  def install
    # See postgis.rb for comments about these settings
    ENV.deparallelize

    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    args = [
      "--disable-dependency-tracking",
      "--disable-nls",

      "--with-projdir=#{HOMEBREW_PREFIX}",
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llwgeom", "-o", "test"
    system "./test"
  end
end

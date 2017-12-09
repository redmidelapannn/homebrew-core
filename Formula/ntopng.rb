class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/3.2.tar.gz"
    sha256 "3d7f7934d983623a586132d2602f25b630614f1d3ae73c56d6290deed1af19ee"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI/archive/2.2.tar.gz"
      sha256 "25607db12f466ba88a1454ef8b378e0e9eb59adffad6baa4b5610859a102a5dd"
    end
  end

  bottle do
    sha256 "f7e119368acd74d37cb29cad2affdd95f7c70f2b3a45090f5b4cf25be2133fd1" => :high_sierra
    sha256 "0330d9a98ffeb689df84db3d9b65cd098da31cbf69758beaeff338878bfeafac" => :sierra
    sha256 "c4454fbfecf4dedd3f32f94ba673ae1dbef71687ddcad4be179f95046ae198eb" => :el_capitan
  end

  head do
    url "https://github.com/ntop/ntopng.git", :branch => "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "dev"
    end
  end

  option "with-mariadb", "Build with mariadb support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "zeromq" => :build
  depends_on "gnutls" => :build

  depends_on "json-c"
  depends_on "rrdtool"
  depends_on "geoip"
  depends_on "redis"
  depends_on "mysql" if build.without? "mariadb"
  depends_on "mariadb" => :optional

  def install
    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath/"nDPI").install Dir["*"]
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ntopng", "-V"
  end
end

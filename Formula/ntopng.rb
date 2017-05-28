class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "http://www.ntop.org/products/ntop/"
  revision 1

  stable do
    url "https://github.com/ntop/ntopng/archive/2.4.tar.gz"
    sha256 "86f8ed46983f46bcd931304d3d992fc1af572b11e461ab9fb4f0f472429bd5dd"

    resource "nDPI" do
      # tip of 1.8-stable branch; four commits beyond the 1.8 tag
      url "https://github.com/ntop/nDPI.git",
        :revision => "6fb81f146e2542cfbf7fab7d53678339c7747b35"
    end
  end

  bottle do
    rebuild 1
    sha256 "9ea8ca19402fc03f45a690eb45399d6c8574cf57563df1a6ac64fcdf8a3e8e3f" => :sierra
    sha256 "0d7b89c1fd72911c06d664cbcb958a34697b721ea1cd1d3c51b649281f7033ae" => :el_capitan
    sha256 "07e8da709de2d53cead766e62abebc0f4320926e13aae550d66ce0bf71bdf80b" => :yosemite
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
  depends_on "luajit"
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
    system "#{bin}/ntopng", "-h"
  end
end

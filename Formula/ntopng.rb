class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "http://www.ntop.org/products/ntop/"

  stable do
    url "https://github.com/ntop/ntopng/archive/3.0.tar.gz"
    sha256 "3780f1e71bc7aa404f40ea9b805d195943cdb5095d712f41669eae138d388ad5"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "2.0-stable"
    end
  end

  bottle do
    rebuild 1
    sha256 "1ee6e4a089df5103e2397e149330ced2b85631bf274657de09c94b5187c239cd" => :sierra
    sha256 "11bcf64d821f9e311a403a072eb1547979111db8574a0fe03cfa7e4c17136f1b" => :el_capitan
    sha256 "861f36dd7f40d37a6d8a0c2fc06ce5b953d4442199c4d0edd9c9e95df3feb513" => :yosemite
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
    if build.with? "mariadb"
      inreplace "configure.seed", "mariadb_config", "mysql_config"
    end

    # Prevent "make install" failure "cp: the -H, -L, and -P options may not be
    # specified with the -r option"
    # Reported 2 Jun 2017 https://github.com/ntop/ntopng/issues/1285
    inreplace "Makefile.in", "cp -Lr", "cp -LR"

    resource("nDPI").stage do
      system "./autogen.sh"
      system "make"
      (buildpath / "nDPI").install Dir["*"]
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

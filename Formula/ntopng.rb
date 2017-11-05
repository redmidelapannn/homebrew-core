class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "https://www.ntop.org/products/traffic-analysis/ntop/"

  stable do
    url "https://github.com/ntop/ntopng/archive/3.0.tar.gz"
    sha256 "3780f1e71bc7aa404f40ea9b805d195943cdb5095d712f41669eae138d388ad5"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "2.0-stable"
    end
  end

  bottle do
    rebuild 1
    sha256 "c3de607ac5ff59f33dbaa4657052a773a5689dee69d1defdf5be792b8447f272" => :high_sierra
    sha256 "a0898baf1aae5cdb68b67912a18ac2ee6bd6d268fdd067530f2087b852254917" => :sierra
    sha256 "945bce3f1937f9dd23ffa24ce00c3b2992132843e9b630641c4e31e5f316d7ea" => :el_capitan
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
    # Prevent "make install" failure "cp: the -H, -L, and -P options may not be
    # specified with the -r option"
    # Reported 2 Jun 2017 https://github.com/ntop/ntopng/issues/1285
    inreplace "Makefile.in", "cp -Lr", "cp -LR"

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

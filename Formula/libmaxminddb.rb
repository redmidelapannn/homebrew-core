class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.2.0/libmaxminddb-1.2.0.tar.gz"
  sha256 "1fe859ed714f94fc902a145453f7e1b5cd928718179ba4c4fcb7f6ae0df7ad37"

  bottle do
    cellar :any
    rebuild 1
    sha256 "34df39530f299dac98d0335dde024709d87ee18b8e2fae8a60de0388053485dc" => :sierra
    sha256 "4ad3608d87832faa75f78647cd2fd5e6deab5d81861aa967dad8e4b78d5b5c0a" => :el_capitan
    sha256 "ee80887e3e5577f837c24ad8a0b75b6d063b000f853bd363b34075558b0f1564" => :yosemite
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoipupdate" => :optional

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end

class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.4.0/libmaxminddb-1.4.0.tar.gz"
  sha256 "24acde13f4f9b5ce6867a7454e794968d5cfc9c9ba56048cc72e736c3e91c1af"

  bottle do
    cellar :any
    sha256 "7c11dcf8ec14518649e9ffefa9c178a941d4103bc94aa89e8091dfc085d9c76a" => :catalina
    sha256 "1994f1dfd44226a0c860b5774f529d4b0e5bc75561e48a1f98d1dc1482a2fea0" => :mojave
    sha256 "38ea3189f1930a8eb46ed102c55409a73690ffea5b5ecc6659e8f3dcc96e50ca" => :high_sierra
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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

class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/0.9.1.tar.gz"
  sha256 "5ad57e0c9a4ec8121e19f13f05bacc41556489dfe8f46ff509af567fdee98d82"

  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "03ffd080053dc66cde63d18ff63068953d5bb0e5a50571acefc77e091a3cccff" => :sierra
    sha256 "6b89f5307c79adfc62710ed7aed09eb15854936d37024296102d756db1c25a9c" => :el_capitan
    sha256 "e09aacba4551ee64487532557d0b37ccd5cf9d4a89b93b3fa9152d7c8e67faf2" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "lzlib"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end

class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.4.0.tar.gz"
  sha256 "ae27ea3f3d0d32d29004e7f709efbba2666c5383a107cc45b3a1949486b2eb84"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "e03a99f9de611b0a71a00c93fb11bc07485b09ab9a2242c26ffd54486ba4689d" => :catalina
    sha256 "03a13107fb8072c49f97b57ff4286350402f2c1349c4424b40ea60667852382f" => :mojave
    sha256 "ae6fee4c82a1e103b52be6f495ec715e796a8c0e9227231fe725a3dafc148858" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        int version = rd_kafka_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end

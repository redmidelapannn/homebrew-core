class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v0.11.5.tar.gz"
  sha256 "cc6ebbcd0a826eec1b8ce1f625ffe71b53ef3290f8192b6cae38412a958f4fd3"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "71b40c265e3f60d09b8213057512b40849e2c17ad607af536303b924c3843e5d" => :mojave
    sha256 "c746e4454d5c8f1216a01faca71f2eb458d8b87ef355a0c2041ba904c1388f2a" => :high_sierra
    sha256 "a93ee9384df4febaf01b1d434cda092c392c161e505e026eadfddb68005c2f43" => :sierra
    sha256 "76c0f7cdcf927cbb4944a790de1123a9320edfbacb61de4d44ea67257e537a6c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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

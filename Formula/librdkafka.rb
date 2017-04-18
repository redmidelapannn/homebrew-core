class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka.git",
    :tag => "v0.9.5",
    :revision => "0d540ab4e78a3e3661fe07ee328e2f61fb77f2c3"

  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "fec8a13e2fccdf97367bc7264705f86f5a4269540be572b0d82503f7c1034fce" => :sierra
    sha256 "b72823fb4ec547d70cc42cc2b9d7e779a3740711ba9755e355037c06fd9757c4" => :el_capitan
    sha256 "77518f07c043540aefc7987834b54e8ded3f728307f9c1dd3e335fd775400484" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "lzlib"
  depends_on "openssl"
  depends_on "lz4" => :recommended

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

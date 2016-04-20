class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/0.9.0.tar.gz"
  sha256 "e7d0d5bbaed8c6b163bdcc74274b7c1608b4d8a06522c4fed1856986aee0a71a"

  bottle do
    cellar :any
    sha256 "4ae6379a8000dbdec3a03ee27ce79c7e126a5c23b3044a9aa387c9338db45c39" => :el_capitan
    sha256 "b19be0abe39f442e5f1e6d65374f2c06770e4223514f09e90cd1d2ea942d8748" => :yosemite
    sha256 "8153a67a0ed172b837cc441c4fd17d458d49bb16cf1086e778c7353456c2492f" => :mavericks
  end

  depends_on "lzlib"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "C_INCLUDE_PATH=.:#{include}:#{Formula["openssl"].opt_prefix}/include make"
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

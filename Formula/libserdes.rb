class Libserdes < Formula
  desc "Avro serialization/deserialization library for C/C++"
  homepage "https://github.com/confluentinc/libserdes"
  url "http://packages.confluent.io/deb/5.3/pool/main/c/confluent-libserdes/confluent-libserdes_5.3.1.orig.tar.gz"
  sha256 "06bcb4066f6f13d2f4ece7987188c1feb9510c36bb5828e3283c267267c3d470"

  bottle do
    cellar :any
    sha256 "c0349579280ea9c2a09387e288557af6e4e92fe6310abbd1608540900257c03d" => :catalina
    sha256 "4698e76f52c30d4c5235213e83a7d7c034b9596f960c637f877394de59f81306" => :mojave
    sha256 "2ba600f3997ec3d5ef1a58601915a79982cec1fd82f5ade0d068fd0b20643d93" => :high_sierra
  end

  depends_on "avro-c"
  depends_on "jansson"
  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <err.h>
      #include <stddef.h>
      #include <sys/types.h>
      #include <libserdes/serdes.h>

      int main()
      {
        char errstr[512];
        serdes_conf_t *sconf = serdes_conf_new(NULL, 0, NULL);
        serdes_t *serdes = serdes_new(sconf, errstr, sizeof(errstr));
        if (serdes == NULL) {
          errx(1, "constructing serdes: %s", errstr);
        }
        serdes_destroy(serdes);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lserdes", "-o", "test"
    system "./test"
  end
end

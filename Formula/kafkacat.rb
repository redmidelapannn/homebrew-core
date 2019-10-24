class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag      => "1.5.0",
      :revision => "3b4bcf00d322533c374e226f2a4eb16501e8a441"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bfd61f840613b37486e58112fdb92d7aafbf8a4d293fd2c7e60cc20254f74614" => :catalina
    sha256 "935e3437f53c22c547a8bb04d32bc0ee845d8e381ef8f0dae69ccac1f4d630a8" => :mojave
    sha256 "142045681705a66727f2fa2a6496a49277631336924ece9c67e59fa3a80de087" => :high_sierra
  end

  depends_on "avro-c"
  depends_on "librdkafka"
  depends_on "libserdes"
  depends_on "yajl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-json",
                          "--enable-avro"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end

class Kafkacat < Formula
  desc "Generic command-line non-JVM Apache Kafka producer and consumer"
  homepage "https://github.com/edenhill/kafkacat"
  url "https://github.com/edenhill/kafkacat.git",
      :tag => "1.3.0",
      :revision => "b79896cceedf81df7873850f38e5e2c4ad3e3e57"
  revision 2

  bottle do
    cellar :any
    sha256 "86716faa5ae931724f47f7dad0f0181c84631b110620a545ccd992f1d8e288e4" => :sierra
    sha256 "25dd21084613d822df35b3559c5e31a8d769f50903afd5df8e9b99771c7c9825" => :el_capitan
    sha256 "35d7c09f50cbb4c0fd22db76e2a3339fa41d6e5b2502dfa35fc0a9918498823d" => :yosemite
  end

  depends_on "librdkafka"
  depends_on "yajl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-json"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"kafkacat", "-X", "list"
  end
end

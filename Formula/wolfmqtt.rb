class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT.git",
      :tag      => "v1.4",
      :revision => "af3d2926773b2c97f5e3a86ea2562e339a91b747"
  head "https://github.com/wolfSSL/wolfMQTT.git"

  bottle do
    cellar :any
    sha256 "91a0b891edee1d2919eaa5a88ce96cbbebc4a6efe177e201345bdd3633bf254a" => :catalina
    sha256 "90f85f7b9017648e50be0f469641044906fca68f360106d08a37da67e8e23c83" => :mojave
    sha256 "a7d6c33f571c515bb99573fd2a90e98b1a077d493a7632f63e8e6e45706e2f20" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wolfssl"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-nonblock
      --enable-mt
      --enable-mqtt5
      --enable-propcb
      --enable-sn
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end

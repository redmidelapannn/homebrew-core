class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/components/cms/"
  url "https://www.apache.org/dyn/closer.lua?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  mirror "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "b9a2c1401bd098838b2eb1c11d36a2ef0ed1d8345e33f11f4f66dce5cb57fc73" => :catalina
    sha256 "d714d5ef823175fcbc38754c13a2100df525161b7c3bda8df3de0221f1f4c152" => :mojave
    sha256 "97972b5a331601ded6983ebbc1542514fa99eeaf2bcdc318dd4997a021890c26" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/activemqcpp-config", "--version"
  end
end

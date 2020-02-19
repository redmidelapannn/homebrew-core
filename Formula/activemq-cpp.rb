class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/components/cms/"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  mirror "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e9ef4b23287846359e8bd285538a29eadd9071f73fdc115d5a05133fcb569d54" => :catalina
    sha256 "e8a669839b1bf46023d261abaa23569a9208824b4b9537fe73bce6026fb986c3" => :mojave
    sha256 "598af877c6393352b495567fc31579534d2b244ea642ee45db655f3fb1641530" => :high_sierra
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

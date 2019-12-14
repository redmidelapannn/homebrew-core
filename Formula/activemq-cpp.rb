class ActivemqCpp < Formula
  desc "C++ API for message brokers such as Apache ActiveMQ"
  homepage "https://activemq.apache.org/components/cms/"
  url "https://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.9.5/activemq-cpp-library-3.9.5-src.tar.bz2"
  sha256 "6bd794818ae5b5567dbdaeb30f0508cc7d03808a4b04e0d24695b2501ba70c15"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "41d9b1bb67b0066b275522c5585eb82dbc944b2d6b9c4f85f1ceb27272512ae0" => :catalina
    sha256 "6abb15d8b4beb98d1455accb17d98076da1a5bd225b05fa9c0863599e8bf6e55" => :mojave
    sha256 "c941066b23823d672d1a2342cbb5c19c160d5f3d8b23775ba2d4c4c2913bc59c" => :high_sierra
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

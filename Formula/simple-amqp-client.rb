class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.4.0.tar.gz"
  sha256 "5735ccccd638b2e2c275ca254f2f947bdfe34511247a32822985c3c25239e06e"
  revision 2

  head "https://github.com/alanxz/SimpleAmqpClient.git"

  bottle do
    cellar :any
    sha256 "8ca0d5bdcda814ff83b2bdc9cd29e47e020f7ea191b3fb47a0e8689d151b2a48" => :sierra
    sha256 "35ac8c833402951417609579fc24a2a92cb63dbd8ac551381ec12f87375a2318" => :el_capitan
    sha256 "d94474d2032d5b29574f60cc5477f75778f3b8f6666135400f3a9c80e4ef05bd" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "rabbitmq-c"
  depends_on "boost@1.61"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end

class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.4.0.tar.gz"
  sha256 "5735ccccd638b2e2c275ca254f2f947bdfe34511247a32822985c3c25239e06e"
  revision 2
  head "https://github.com/alanxz/SimpleAmqpClient.git"

  bottle do
    cellar :any
    sha256 "ef508a1e7ac8669e01f2afea3ddb78c413334c33305059db1252ee2f722453dc" => :mojave
    sha256 "fdb23a79897652487a4150d65f0b82e0db2ee02b071a7d963206dec0e35d285c" => :high_sierra
    sha256 "604350eb90eb1e900361db83ae270509234e431cae396ee4afc785a510a1942b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end

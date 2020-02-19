class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.30.0/qpid-proton-0.30.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.30.0/qpid-proton-0.30.0.tar.gz"
  sha256 "e37fd8fb13391c3996f927839969a8f66edf35612392d0611eeac6e39e48dd33"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a9ded0c576689823bcbb24efa4c33c57216f7f7e45d57d011af72331f7a46e82" => :catalina
    sha256 "6416a0734794696f2b5a6c3b827d09eb9ddef8ddfb04344215d7bda39cd2c1b1" => :mojave
    sha256 "eb8ee38df7cf2b8361dcc6e8923895575f0865f7b1d132b746ebdf8d82efe9f2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libuv"
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_BINDINGS=",
                         "-DLIB_INSTALL_DIR=#{lib}",
                         "-Dproactor=libuv",
                         *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "proton/message.h"
      #include "proton/messenger.h"
      int main()
      {
          pn_message_t * message;
          pn_messenger_t * messenger;
          pn_data_t * body;
          message = pn_message();
          messenger = pn_messenger(NULL);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lqpid-proton", "-o", "test"
    system "./test"
  end
end

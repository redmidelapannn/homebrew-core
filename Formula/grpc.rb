class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  head "https://github.com/grpc/grpc.git"

  stable do
    url "https://github.com/grpc/grpc/archive/v1.7.1.tar.gz"
    sha256 "6b2bb798652ce5758130f62cbd31b9ce6e453dd1e59b710edf6ca0261c6db077"
  end

  bottle do
    sha256 "efedf24ac3ab35d250be476c29b236d5552d624fcfd50217c3b00135536af0ec" => :high_sierra
    sha256 "8a809b53037b5a66dabe42b694fe8445b2eaea7d5a417344eefb29212ebf0d48" => :sierra
    sha256 "79126a0d3816f20c97eda6f6835736a3f5cbe46834231a1380d384c706943948" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "openssl"
  depends_on "protobuf"
  depends_on "gflags"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
    sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"
  end

  def install
    system "make", "install", "prefix=#{prefix}"

    system "make", "install-plugins", "prefix=#{prefix}"

    (buildpath/"third_party/googletest").install resource("gtest")
    system "make", "grpc_cli", "prefix=#{prefix}"
    bin.install "bins/opt/grpc_cli"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <grpc/grpc.h>
      int main() {
        grpc_init();
        grpc_shutdown();
        return GRPC_STATUS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lgrpc", "-o", "test"
    system "./test"
  end
end

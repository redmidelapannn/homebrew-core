class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.23.0.tar.gz"
  sha256 "f56ced18740895b943418fa29575a65cc2396ccfa3159fa40d318ef5f59471f9"
  revision 3
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "02d213b6bddfc65996cdf7b516c78577686253bae9219bb66f384f40077ab100" => :mojave
    sha256 "d8893d098c0639e4f9db87539d43669639527e020bafca05ea96e4ee5ff3bb5e" => :high_sierra
    sha256 "8207ff793f9c4869ce9df57271b8f8ddf6d57e6ed3c4bf0e1b26820c77e29ab0" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "gperftools"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
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

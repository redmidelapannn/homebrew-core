class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    :tag      => "v1.28.0",
    :revision => "c5789be22cada39b80d70d4ace3738d62f1c0a04",
    :shallow  => false
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "fbf3e872cd92459bffe071be6b766249f69bb5895bf23ce05a16d4731b568103" => :catalina
    sha256 "4965efa3af11f2406f4cb4f1f2f1fd53a49ad0d6a37d31f10891116cbe96777f" => :mojave
    sha256 "ccec8fcc2fc4293f14f7224d9f04a84cbd36387eb1c73b3527a996b6125c4e01" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "c-ares"
  depends_on "gflags"
  depends_on "openssl@1.1"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
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

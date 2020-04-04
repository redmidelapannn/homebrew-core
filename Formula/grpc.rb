class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://grpc.io/"
  url "https://github.com/grpc/grpc.git",
    :tag      => "v1.28.1",
    :revision => "cb81fe0dfaa424eb50de26fb7c904a27a78c3f76",
    :shallow  => false
  head "https://github.com/grpc/grpc.git"

  bottle do
    sha256 "29bb08ec7f9641297e9c8ad3a46a85e10a1a3ec3f48d6571aba3d990e81226eb" => :catalina
    sha256 "64653e3c8549e05c35bbb7ef6d0ff07df1170c5d28b6e1a8faad8d75c46fa0fb" => :mojave
    sha256 "77effc80a8b60353e0adba01d6f16ba63f737d899f9018d5fc53569324a6534a" => :high_sierra
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

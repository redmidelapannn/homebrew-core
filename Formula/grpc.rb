class Grpc < Formula
  desc "Next generation open source RPC library and framework"
  homepage "https://www.grpc.io/"
  url "https://github.com/grpc/grpc/archive/v1.17.2.tar.gz"
  sha256 "34ed95b727e7c6fcbf85e5eb422e962788e21707b712fdb4caf931553c2c6dbc"
  head "https://github.com/grpc/grpc.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9206aa310a76bb39b20b3b5fd7321c276e2117965f7687ee8760230d32fc5600" => :mojave
    sha256 "223af963241ddc5797217e51e85537036f3a6ff8c0e2fd3585bed9f45e7c1e17" => :high_sierra
    sha256 "5026f57838257ff9e2873af8391e62ed9201f7c430b76573e2731ac83c7dbe51" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "google-benchmark" => :build
  depends_on "c-ares"
  depends_on "openssl"
  depends_on "protobuf"

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.8.1.tar.gz"
    sha256 "9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c"
  end

  def install
    (buildpath/"third_party/googletest").install resource("gtest")
    system "cmake", "-G", "Unix Makefiles",
        # we need to build tests to get grpc_cli
        "-DgRPC_BUILD_TESTS=ON",
        "-DgRPC_ZLIB_PROVIDER=package",
        "-DgRPC_CARES_PROVIDER=package",
        "-DgRPC_SSL_PROVIDER=package",
        "-DgRPC_PROTOBUF_PROVIDER=package",
        "-DgRPC_GFLAGS_PROVIDER=package",
        "-DgRPC_BENCHMARK_PROVIDER=package",
        *std_cmake_args
    system "make", "install"
    bin.install "grpc_cli"
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

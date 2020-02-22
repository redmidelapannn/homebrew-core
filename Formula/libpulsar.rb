class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.4.2/apache-pulsar-2.4.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.4.2/apache-pulsar-2.4.2-src.tar.gz"
  sha256 "4b543932db923aa135c4d54b9122bcbdfc67bd73de641f9fffbc9a4ddf3430ae"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "36607c0fcd707ee3929e7a09575e6f2e9d745bcbe980782889e052c26765a218" => :catalina
    sha256 "ed55289d2aaacbef2afc1b1f43e855efc6a3fb2562a4ee7eee301b769bfe4cbf" => :mojave
    sha256 "00f4c83b3c9ed1ffbb4e4e2f69b82633609b6875c78b2394363c952af5105d8f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  def install
    cd "pulsar-client-cpp" do
      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_TESTS=OFF",
                      "-DBUILD_PYTHON_WRAPPER=OFF",
                      "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                      "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                      "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib"
      system "make", "pulsarShared", "pulsarStatic"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end

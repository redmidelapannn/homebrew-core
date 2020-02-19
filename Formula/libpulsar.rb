class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.2/apache-pulsar-2.4.2-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.4.2/apache-pulsar-2.4.2-src.tar.gz"
  sha256 "4b543932db923aa135c4d54b9122bcbdfc67bd73de641f9fffbc9a4ddf3430ae"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "c581f33538280e7e2268f76aa415f66914307e8b071e299b3cfe8031f051050c" => :catalina
    sha256 "fb8c8fe65428b10d2af4c6b5c29ed1dfc72541cb3e80636b78559a60c8f0d324" => :mojave
    sha256 "170a11ad600f48542fa1d850611bc69b62b8b41c3ae33134b4624be1a68c5e61" => :high_sierra
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

class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.4.1/apache-pulsar-2.4.1-src.tar.gz"
  sha256 "6fb764b0d15506884905b781cfd2f678ad6a819f2c8d60cc34f78966b4676d40"

  bottle do
    cellar :any
    sha256 "290ddc98bdf6ff8d4d527a4bb7051e5b38c577768870bde489967fe15c16e7ef" => :mojave
    sha256 "3fe3a3877ee840b82a9175510b45100d2a7a3c37e15fbd6afc28a86cf6996fd8" => :high_sierra
    sha256 "8726f234bb9547a087c067de8693c50b61ec595b74df49f90089555934848d51" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "zstd"

  def install
    cd "pulsar-client-cpp" do
      # Stop opportunistic linking to snappy
      # Broken in 2.4.0
      inreplace "CMakeLists.txt",
                "HAS_SNAPPY 1",
                "HAS_SNAPPY 0"

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

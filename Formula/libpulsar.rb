class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=pulsar/pulsar-2.2.1/apache-pulsar-2.2.1-src.tar.gz"
  sha256 "3a365368f0d7beba091ba3a6d0f703dcc77545c8b454e5e33b72c1a29905232e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d5889a6b1b18368d035844401e9f71b2ef54544a37059f13249fa330a3f4410c" => :mojave
    sha256 "1cbfce37675dd459e7ee2c12ac3d244e18c584727c9aef04c68e259b857a6a55" => :high_sierra
    sha256 "21e078c82058d72f6cc48421fd1d4bca19ff348ebdc25cd7258e0b5b6e2feaa5" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "jsoncpp"
  depends_on "openssl"
  depends_on "protobuf"

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
    system ENV.cxx, "test.cc", "-I#{Formula["boost"].include}", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end

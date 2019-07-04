class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.14.0/apache-arrow-0.14.0.tar.gz"
  sha256 "71e668e1901a06211d3f7ab6b6c7cb80ab1c81bb0d22885be42b74782e953470"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "aa56b4d607b697679b35f84c1db5ba35eff61f4e11b4bad8962de81cb3900e1b" => :mojave
    sha256 "672b1985c0ce9a0644a1c7dadfc9cc823524293ec7a818794b15f3ee51a0d122" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "flatbuffers"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "python"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "zstd"

  def install
    ENV.cxx11
    args = %W[
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DFLATBUFFERS_HOME=#{Formula["flatbuffers"].prefix}
      -DLZ4_HOME=#{Formula["lz4"].prefix}
      -DPROTOBUF_HOME=#{Formula["protobuf"].prefix}
      -DPYTHON_EXECUTABLE=#{Formula["python"].bin/"python3"}
      -DSNAPPY_HOME=#{Formula["snappy"].prefix}
      -DTHRIFT_HOME=#{Formula["thrift"].prefix}
      -DZSTD_HOME=#{Formula["zstd"].prefix}
    ]

    mkdir "build"
    cd "build" do
      system "cmake", "../cpp", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end

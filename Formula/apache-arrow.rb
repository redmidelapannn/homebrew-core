class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.9.0/apache-arrow-0.9.0.tar.gz"
  sha256 "beb1c684b2f7737f64407a7b19eb7a12061eec8de3b06ef6e8af95d5a30b899a"
  revision 1
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "60796763e5c75a0d40a8d94809bd9869df959d237b4df1a4ebcaeb863c27e964" => :high_sierra
    sha256 "146498faa5fc3663eb6b1c777edc627ad274dcf3d9f0fa0a77b790f0a54d6071" => :sierra
    sha256 "137d7f0ab4dd21a92ef07099995ed051b9fa2a6fcb7cfdee3639bb122a7f03c5" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"

  needs :cxx11

  # Arrow build error with the latest clang-10 https://github.com/apache/arrow/issues/2105
  # Will be fixed in next release.
  patch do
    url "https://github.com/apache/arrow/pull/2106.patch?full_index=1"
    sha256 "545a733304e1f9e62b70b6e9c8dc9cae5b33f7b9c32e1df8d47a375d66296ae6"
  end

  def install
    ENV.cxx11

    cd "cpp" do
      system "cmake", ".", *std_cmake_args
      system "make", "unittest"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void)
      {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end

class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://archive.apache.org/dist/arrow/arrow-0.12.0/apache-arrow-0.12.0.tar.gz"
  sha256 "34dae7e4dde9274e9a52610683e78a80f3ca312258ad9e9f2c0973cf44247a98"

  bottle do
    cellar :any
    sha256 "a9d9924c925b95727ed9b80c39754b6dbfb4e0440d92b17a14f55681913b06fc" => :mojave
    sha256 "3c10303415e9aac2e97fcfe62ff4c8f4ce6c9f33da6732fc980e2532043aa7e3" => :high_sierra
    sha256 "5b22da1e00749ca1844da837917efb9098959bdb9d75a28fb9527b738a4ea731" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "python" => :optional
  depends_on "python@2" => :optional

  def install
    ENV.cxx11
    args = []

    if build.with?("python") && build.with?("python@2")
      odie "Cannot provide both --with-python and --with-python@2"
    end
    Language::Python.each_python(build) do |python, _version|
      args << "-DARROW_PYTHON=1" << "-DPYTHON_EXECUTABLE=#{which python}"
    end

    cd "cpp" do
      system "cmake", ".", "-DARROW_JEMALLOC=FALSE", *std_cmake_args, *args
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
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
    sha256 "134d9fe3cff8a494593f5cb6632b787dc181d68c11fb59d9f813acae0a6b511b" => :high_sierra
    sha256 "7d76b3fba79b844313396e12b04eb7cf233223894466d833fa3fe4af8b291e17" => :sierra
    sha256 "d4c9de5954e4c071f0426e70b2b11a11e95c73f978b5a6b974508e8cde4f1ca6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"
  depends_on "python" => :optional
  depends_on "python@2" => :optional

  needs :cxx11

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
      system "cmake", ".", *std_cmake_args, *args
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

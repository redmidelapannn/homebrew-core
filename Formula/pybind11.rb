class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.4.2.tar.gz"
  sha256 "e212e3043cb7a15466abb8896c6924c1ce40ae2988d8c24c111afcb30735fb8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "28357dee66a3631cf0afba7701bef2d4fb4f748c415c70d23aac802e6532fbbe" => :catalina
    sha256 "28357dee66a3631cf0afba7701bef2d4fb4f748c415c70d23aac802e6532fbbe" => :mojave
    sha256 "28357dee66a3631cf0afba7701bef2d4fb4f748c415c70d23aac802e6532fbbe" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python"

  def install
    system "cmake", ".", "-DPYBIND11_TEST=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_PLUGIN(example) {
          py::module m("example", "pybind11 example plugin");
          m.def("add", &add, "A function which adds two numbers");
          return m.ptr();
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    python_flags = `python3-config --cflags --ldflags`.split(" ")
    system ENV.cxx, "-O3", "-shared", "-std=c++11", *python_flags, "example.cpp", "-o", "example.so"
    system "python3", "example.py"
  end
end

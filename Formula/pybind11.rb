class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.2.3.tar.gz"
  sha256 "3a3b7b651afab1c5ba557f4c37d785a522b8030dfc765da26adc2ecd1de940ea"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "58217c23f1ce209a0a5982faff33f4dadd52ff44b233b6c1f3b719877f0ce65e" => :high_sierra
    sha256 "58217c23f1ce209a0a5982faff33f4dadd52ff44b233b6c1f3b719877f0ce65e" => :sierra
    sha256 "58217c23f1ce209a0a5982faff33f4dadd52ff44b233b6c1f3b719877f0ce65e" => :el_capitan
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

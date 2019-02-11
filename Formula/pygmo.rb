class Pygmo < Formula
  desc "Scientific Python library for massively parallel optimization"
  homepage "https://esa.github.io/pagmo2/"
  url "https://github.com/esa/pagmo2/archive/v2.10.tar.gz"
  sha256 "2fa95e2b464ddeadb9fc09bd314081293f02a1b6abc11c0b05064729a077227c"

  bottle do
    sha256 "f23ceaea0fc1aa2035bba7eb933d2cb8df722dd363bf846dfc32ef2a7b29bc6f" => :mojave
    sha256 "d0c2afd4081c13d8112f00ef1f06efe4100600538cbb95a8b6d3e0711f2a3935" => :high_sierra
    sha256 "b4575194427cf14048534e12394a47f79de9f25fa3c4ba1dfac09b4f5938f800" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost-python"
  depends_on "numpy"
  depends_on "pagmo"

  def install
    ENV.cxx11
    system "cmake", ".", "-DPAGMO_BUILD_PAGMO=OFF", "-DPAGMO_BUILD_PYGMO=ON",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    system "python", "-c", "import pygmo; pygmo.test.run_test_suite(1)"
  end
end

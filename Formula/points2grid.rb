class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 5

  bottle do
    cellar :any
    sha256 "379ff767d2c078f6fbd01e7901726a3b84b8372cd10f510512f723dc30ee5cb4" => :catalina
    sha256 "5b6ad9821a43ddcd1724c0a6c83b09c7f89377161022379b6ba8e207822c7c0a" => :mojave
    sha256 "d8858c165b87c2f8c8453ac405ced9da1270594d606854cddb6de723732e6ae8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gdal"

  def install
    ENV.cxx11
    libexec.install "test/data/example.las"
    system "cmake", ".", *std_cmake_args, "-DWITH_GDAL=ON"
    system "make", "install"
  end

  test do
    system bin/"points2grid", "-i", libexec/"example.las",
                              "-o", "example",
                              "--max", "--output_format", "grid"
    assert_equal 13, File.read("example.max.grid").scan("423.820000").size
  end
end

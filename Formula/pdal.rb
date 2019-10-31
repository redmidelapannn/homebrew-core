class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.0.1/PDAL-2.0.1-src.tar.gz"
  sha256 "7632808f49ff7defa042e810ab8696beb3e59458082126edd14f7be7ae463cbe"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "fa886eb2c38f2fd057b45d32788900d5a7fadd56e9e52cef0adc3f2cac2e93d4" => :catalina
    sha256 "13788f8ac4f94a1aade2e3496ff2dc6fdb8ae7fa1463d0b02bcfbd6c354a794c" => :mojave
    sha256 "1281a25c444ed28ce1f60e23d63dd99f70b5841c899d83f63539c0fa98cf1902" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "numpy"
  depends_on "pcl"
  depends_on "postgresql"

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PCL=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end

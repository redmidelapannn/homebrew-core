class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.0.1/PDAL-2.0.1-src.tar.gz"
  sha256 "7632808f49ff7defa042e810ab8696beb3e59458082126edd14f7be7ae463cbe"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "6062664ebdc59c21a432e7da56bd94b0594f01739d25f7b1363273f5aa526e43" => :catalina
    sha256 "79ae3ae2194b597d0726291f184f507fe939f0760d1e71ed37f754ad7ae9e8ae" => :mojave
    sha256 "03d1cd2ca44e7f61046521f597fea8bf8a2b52db6272835797a1b650053f10a5" => :high_sierra
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

class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/1.9.0/PDAL-1.9.0-src.tar.gz"
  sha256 "bc010da5259bf2adecce9543696e8c17e7c177da70e3774f60b329d8e02d9cd8"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "63097532deff1539c54b4f981862847f4bb75012e015efc3fb0c2757035fec49" => :mojave
    sha256 "cee2cc85fc411fe12d644a076867365422c862d8b87a8309436d8fcb2fea6c96" => :high_sierra
    sha256 "3c6fc95e2e5c8764d4fb4b2a15dd5b67fc54d2a91dfe2fca2d35ac8cf59b1bc3" => :sierra
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

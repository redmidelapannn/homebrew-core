class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.7.2.tar.gz"
  sha256 "cedfefbe54ca61cbb33d100d619c53873d84f480ff53deec2cf6dd91580f6a61"
  revision 1
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "86bd198f9ddadfd92e694e2bacdd65f27a85ddacd353a0d21495c87fcaf76405" => :high_sierra
    sha256 "0ab04d198c9a0dfc189c423a0538bd2dfdeec3558526bd541d9682fd068bb288" => :sierra
    sha256 "0ada5584d3945b2392b999cc5b8a50a19a7b9984a15554e20b3c3914863dd372" => :el_capitan
  end

  depends_on "cmake" => :build
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

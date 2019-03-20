class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.8.0.tar.gz"
  sha256 "ef3a32c06865383feac46fd7eb7491f034cad6b0b246b3c917271ae0c8f25b69"
  revision 3
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "a2711797e881320976f5467b39269e08b00dc195c2dc31303f57f8c37aa3e18c" => :mojave
    sha256 "5a31e757a6390584cd5f38c0a9a7fabd59589be2acf9f68ab623b18d7d7532ba" => :high_sierra
    sha256 "790d8c9ca243b9902e9cbf8f6cfcfba0fcf4c5e41b39dcb1892daa456833e179" => :sierra
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

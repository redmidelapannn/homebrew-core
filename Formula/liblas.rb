class Liblas < Formula
  desc "C/C++ library for reading and writing the LAS LiDAR format"
  homepage "http://liblas.org"
  url "http://download.osgeo.org/liblas/libLAS-1.8.0.tar.bz2"
  sha256 "17310082845e45e5c4cece78af98ee93aa5d992bf6d4ba9a6e9f477228738d7a"
  revision 2

  head "https://github.com/libLAS/libLAS.git"

  bottle do
    sha256 "549f0984f540d2983c6a454334e0b45305c9af0b46960d163fd43e05b1ee1859" => :sierra
    sha256 "0f0a0e6a40b89ff03c3f4a35204b56e89e2520368f4771debc4addc966769dc5" => :el_capitan
    sha256 "28afedb96ad11a97bdfe439d974fbf9ac5e1e445b803c1c1e66b13f0f05aa323" => :yosemite
  end

  option "with-test", "Verify during install with `make test`"

  depends_on "cmake" => :build
  depends_on "libgeotiff"
  depends_on "gdal"
  depends_on "boost@1.61"
  depends_on "laszip" => :optional

  def install
    mkdir "macbuild" do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   http://liblas.org/compilation.html
      ENV["Boost_INCLUDE_DIR"] = "#{HOMEBREW_PREFIX}/include"
      ENV["Boost_LIBRARY_DIRS"] = "#{HOMEBREW_PREFIX}/lib"
      args = ["-DWITH_GEOTIFF=ON", "-DWITH_GDAL=ON"] + std_cmake_args
      args << "-DWITH_LASZIP=ON" if build.with? "laszip"

      system "cmake", "..", *args
      system "make"
      system "make", "test" if build.bottle? || build.with?("test")
      system "make", "install"
    end
  end

  test do
    system bin/"liblas-config", "--version"
  end
end

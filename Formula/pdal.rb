class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.4.0.tar.gz"
  sha256 "199b34f77d48e468ff2dd2077766b63893d6be99a1db28cadfaee4f92978aed1"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    rebuild 1
    sha256 "0817ee3d5bd80b1ca5714ca14016a4d6b0f2a1a23594b979dde88deade88d4ff" => :sierra
    sha256 "1ac5a44dfbb9563094c7f2e943d8ec9c44ab7eae98e1478d18e3c8a40714ab3c" => :el_capitan
    sha256 "9897728f3872ed3f872bb7167fb485e5e984746e8b52460fb39533f312dd6b41" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "laszip" => :optional

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    args = std_cmake_args
    if build.with? "laszip"
      args << "-DWITH_LASZIP=TRUE"
    else
      # CMake Error LASZIP_LIBRARY set to NOTFOUND
      # Reported 16 Dec 2016 https://github.com/PDAL/PDAL/issues/1446
      inreplace "CMakeLists.txt", "        ${LASZIP_LIBRARY}\n", ""

      args << "-DWITH_LASZIP=FALSE"
    end

    system "cmake", ".", *args
    system "make", "install"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end

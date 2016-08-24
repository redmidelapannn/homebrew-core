class Pdal < Formula
  desc "Point data abstraction library"
  homepage "http://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.1.0.tar.gz"
  sha256 "70e0c84035b3fdc75c4eb72dde62a7a2138171d249f2a607170f79d5cafe589d"
  head "https://github.com/PDAL/PDAL.git"

  bottle do
    rebuild 1
    sha256 "22482e0056bbe115da2e9b5ff0a15b43e35ab0c640c4bc5c8118e67bba398825" => :el_capitan
    sha256 "d97954a96e923c96e9556cb1eed8cfcd21cbe877f4cd6275c63dedd6531a4cc4" => :yosemite
    sha256 "251672b9e48c6eb127bcc70bd22c831c2d6bff4b5b7e2cfd46342b6ee3977808" => :mavericks
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

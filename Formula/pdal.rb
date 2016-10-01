class Pdal < Formula
  desc "Point data abstraction library"
  homepage "http://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/archive/1.1.0.tar.gz"
  sha256 "70e0c84035b3fdc75c4eb72dde62a7a2138171d249f2a607170f79d5cafe589d"
  revision 1

  head "https://github.com/PDAL/PDAL.git"

  bottle do
    sha256 "60928612ce9cc8ad5f3093ff53a82f69f711792a67f87814050f1dd019d7fcea" => :sierra
    sha256 "b6fd94ca799d223753498953e0c9b96fde5b1c656a76996895340811a9b17024" => :el_capitan
    sha256 "5e0a84c303640958568db6468347d85eadce19331b238bce26b7f693ba31b1e9" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "laszip" => :optional

  if MacOS.version < :mavericks
    depends_on "boost@1.61" => "c++11"
  else
    depends_on "boost@1.61"
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

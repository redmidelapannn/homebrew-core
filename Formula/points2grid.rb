class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 1

  bottle do
    cellar :any
    sha256 "b3fee075cc384f111b135d5c7cb70856f25f98b0d57dfdcbe5c5254f92efd050" => :sierra
    sha256 "5e1ed39cf562e12b19cf16e687d98daa48b8f13718f3555db454a2ca840182dd" => :el_capitan
    sha256 "268b83cdaa89c0a6fdeeea64a5b260e60b27f14c390b4ad7563cb535b85c1b1b" => :yosemite
  end

  depends_on :macos => :mavericks

  depends_on "cmake" => :build
  depends_on "boost@1.61"
  depends_on "gdal"

  def install
    args = std_cmake_args + ["-DWITH_GDAL=ON"]
    libexec.install "test/data/example.las"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system bin/"points2grid",
           "-i", libexec/"example.las",
           "-o", "example",
           "--max", "--output_format", "grid"
    assert_equal 13, File.read("example.max.grid").scan("423.820000").size
  end
end

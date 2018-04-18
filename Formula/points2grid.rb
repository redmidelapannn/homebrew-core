class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 3

  bottle do
    cellar :any
    rebuild 1
    sha256 "2ae8942ce5b99edd04422481cdc9f9020e9e63b625ff3256e6f2a64105a41bbc" => :high_sierra
    sha256 "da79c5852bbf6f7cbe581576bfa5daf52bc4c90c07c3ebd173c3e51f1b5432cb" => :sierra
    sha256 "85b3cf29e1782b941a108b2b285c17b6e01d000d62b9cf7182b6d4f966ec7806" => :el_capitan
  end

  depends_on :macos => :mavericks

  depends_on "cmake" => :build
  depends_on "boost"
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

class Points2grid < Formula
  desc "Generate digital elevation models using local griding"
  homepage "https://github.com/CRREL/points2grid"
  url "https://github.com/CRREL/points2grid/archive/1.3.1.tar.gz"
  sha256 "6e2f2d3bbfd6f0f5c2d0c7d263cbd5453745a6fbe3113a3a2a630a997f4a1807"
  revision 5

  bottle do
    cellar :any
    sha256 "3f88ebdd9d48293477ed9584401b7e5febd30f6f35403c08be6658ccc0a27df5" => :catalina
    sha256 "0796c0dff158678cfcc5c3ad18074b68906a5f9c8d8a92239b2f92d82825db5a" => :mojave
    sha256 "8739468ae7b5e644fa2ce574579ff02150cada9b2a108bbf232139e87e7486d2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gdal"

  def install
    ENV.cxx11
    libexec.install "test/data/example.las"
    system "cmake", ".", *std_cmake_args, "-DWITH_GDAL=ON"
    system "make", "install"
  end

  test do
    system bin/"points2grid", "-i", libexec/"example.las",
                              "-o", "example",
                              "--max", "--output_format", "grid"
    assert_equal 13, File.read("example.max.grid").scan("423.820000").size
  end
end

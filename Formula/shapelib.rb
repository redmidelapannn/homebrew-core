class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "https://download.osgeo.org/shapelib/shapelib-1.4.1.tar.gz"
  sha256 "a4c94817365761a3a4c21bb3ca1c680a6bdfd3edd61df9fdd291d3e7645923b3"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b06666dbba7f20f8ec6b4cb373d83e0160c15b348a17a0be6fc5f8c93ae65966" => :high_sierra
    sha256 "2a43fec2a3e4c058eee784f9f485c879029d4e1aac8793c6795ce33fcaab8a05" => :sierra
    sha256 "6171e58a152ce83947b24f422d9a18c1b494f911b9d252139b4991355284efc4" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "shp_file", shell_output("#{bin}/shptreedump", 1)
  end
end

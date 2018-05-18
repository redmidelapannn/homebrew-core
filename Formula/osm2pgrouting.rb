class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "https://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting.git",
      :revision => "5de05744abf2ddbd6c0b70ca1e5aa9cf19ce8c26"
  version "2.3.5-alpha1"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "6026e48fdf1d3f145d4eba9cef5523447bf8413b0f00fead72a02cd2de08d12c" => :high_sierra
    sha256 "d924269d8f9e423de7f6fe10bad10ccc6b173a79bbccb0a603e3ff70368c58f1" => :sierra
    sha256 "f8a301f4837cbb2d71451c21d9aa21baf7a5a6be8328dfd5bd72c793d214a250" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "libpqxx"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end

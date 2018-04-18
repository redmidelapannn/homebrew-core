class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.4.tar.gz"
  sha256 "32aba345013e137e39cc7bf74466cc6c97b93e256f2754e617a00f61f57eb8c2"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1fb6b711498dda20f2b1c3c5383687af7f2f757114146565ecc514b2f19f1940" => :sierra
    sha256 "0927d73c05ed5a6bd338d1d8dc0b55d7fcc70e902030e1132a9145f31a3fb35e" => :el_capitan
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

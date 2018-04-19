class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.4.tar.gz"
  sha256 "32aba345013e137e39cc7bf74466cc6c97b93e256f2754e617a00f61f57eb8c2"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0d7f150b1fc29f021dbb0966e52f96a6e0637c1a0d2466e615897a694234dc5d" => :sierra
    sha256 "d1f7ff0b56339f0fbaa22f20f4af0bf17bc4f12909db9f33a0f1342c3eeee4de" => :el_capitan
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

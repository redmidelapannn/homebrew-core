class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.96.0.tar.gz"
  sha256 "b6020e77d88772989279a69ae4678e9782989b630613754e483b5192cd39c723"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    rebuild 1
    sha256 "4ef303b7bdd173a072674d6576bf51128edc4a2636a5dd80b37dfe1eca04c5e3" => :mojave
    sha256 "3fec0dacdd24318223450477143caea55ea790195814030521191d32c2b97a7f" => :high_sierra
    sha256 "28c3ed5870efd1552cbc9687fa821e998f9d8c50fb9a50c462a38005d7790d05" => :sierra
    sha256 "a5692f0939997ed580797ede95d65694b832ede49ebb3a35084fb23ca4e1ea48" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "geos"
  depends_on "lua"
  depends_on "postgresql"
  depends_on "proj"

  def install
    args = std_cmake_args

    # This is essentially a CMake disrespects superenv problem
    # rather than an upstream issue to handle.
    lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
    inreplace "cmake/FindLua.cmake", "LUA_VERSIONS5 5.3 5.2 5.1 5.0",
                                     "LUA_VERSIONS5 #{lua_version}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end

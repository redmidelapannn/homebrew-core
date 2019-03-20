class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.96.0.tar.gz"
  sha256 "b6020e77d88772989279a69ae4678e9782989b630613754e483b5192cd39c723"
  revision 1
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    sha256 "950df68bc7d543578549ecf3f764e08021dfd7336ee264a0ed94916a870da041" => :mojave
    sha256 "f306f2aeaec7470ce7390b46619a50827cb9e80da706db622ff04182599b50f3" => :high_sierra
    sha256 "5ade475bf10c4ebd7d016b0456dc9ac3d514c3bf65ff6c34184bd5bb9ea1495b" => :sierra
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

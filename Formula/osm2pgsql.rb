class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.1.tar.gz"
  sha256 "0912a344aaa38ed4b78f6dcab1a873975adb434dcc31cdd6fec3ec6a30025390"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    rebuild 1
    sha256 "2ba64a99a420d6516f453c1750df9196a59afd73bf419120c98556eddc4914dd" => :sierra
    sha256 "6020556b4e4bfaa002c8f46c8d2b43d978125a2c6e8974d7be0e79c2a0370bb1" => :el_capitan
    sha256 "1fbfe43541190a959342de18df5250eef18cb8fad74979e51a9f9a0afed31042" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

  # Compatibility with GEOS 3.6.1
  # Upstream PR from 27 Oct 2016 "Geos36"
  patch do
    url "https://github.com/openstreetmap/osm2pgsql/pull/636.patch"
    sha256 "89d1edb197d79a5567636ca0574d68877a31b82157ae8ad549614fd8327a4c79"
  end

  def install
    args = std_cmake_args

    if build.with? "lua"
      # This is essentially a CMake disrespects superenv problem
      # rather than an upstream issue to handle.
      lua_version = Formula["lua"].version.to_s.match(/\d\.\d/)
      inreplace "cmake/FindLua.cmake", "LUA_VERSIONS5 5.3 5.2 5.1 5.0",
                                       "LUA_VERSIONS5 #{lua_version}"
    else
      args << "-DWITH_LUA=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end

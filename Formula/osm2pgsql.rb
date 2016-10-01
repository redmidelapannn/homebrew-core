class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  revision 1

  head "https://github.com/openstreetmap/osm2pgsql.git"

  stable do
    url "https://github.com/openstreetmap/osm2pgsql/archive/0.90.1.tar.gz"
    sha256 "f9ba09714603db251e4a357c1968640c350b0ca5c99712008dadc71c0c3e898b"

    # Remove for >0.90.1; adds the option to build without lua (-DWITH_LUA=OFF)
    patch do
      url "https://github.com/openstreetmap/osm2pgsql/commit/dbbca884.patch"
      sha256 "1efce5c8feeb3646450bee567582252b15634c7e139d4aa73058efbd8236fb60"
    end
  end

  bottle do
    sha256 "c21a625e83462ad762a6ffc2f61e22168b4ff8a2733351a5f1cf68772e98d2e7" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost@1.61"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua" => :recommended

  def install
    args = std_cmake_args
    args << "-DWITH_LUA=OFF" if build.without? "lua"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osm2pgsql -h 2>&1")
  end
end

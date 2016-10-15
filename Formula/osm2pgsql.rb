class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  head "https://github.com/openstreetmap/osm2pgsql.git"
  revision 2

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
    sha256 "33d562562555cdf762634a99d5441a1c4bdc36eeea4a6a5229be8a693f590e8f" => :sierra
    sha256 "89a3c883cec0a0cca9941d590945aac94c865f3f24c9b91042366b2ae32ab576" => :el_capitan
    sha256 "ec32cf8011c9d5cadbc5bac1a151afc3eaa64a594310df967ee834d6806b92aa" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
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

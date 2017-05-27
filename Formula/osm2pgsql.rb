class Osm2pgsql < Formula
  desc "OpenStreetMap data to PostgreSQL converter"
  homepage "https://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.92.1.tar.gz"
  sha256 "0912a344aaa38ed4b78f6dcab1a873975adb434dcc31cdd6fec3ec6a30025390"
  head "https://github.com/openstreetmap/osm2pgsql.git"

  bottle do
    rebuild 1
    sha256 "ffe475fa40d5b40b1cd94fc7e86e995790f42e6f11f2d2148a483dd51dd562f3" => :sierra
    sha256 "0687e9be7b247c6fa7577a600c3968c498473f54ebad0cfb8fe5b2409f6a5649" => :el_capitan
    sha256 "2d43960fc0a63f6b12c254799326905d063eb5c225b46a0bf367d045c792f474" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :postgresql
  depends_on "boost"
  depends_on "geos"
  depends_on "proj"
  depends_on "lua"

  # Compatibility with GEOS 3.6.1
  # Upstream PR from 27 Oct 2016 "Geos36"
  patch do
    url "https://github.com/openstreetmap/osm2pgsql/pull/636.patch"
    sha256 "89d1edb197d79a5567636ca0574d68877a31b82157ae8ad549614fd8327a4c79"
  end

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

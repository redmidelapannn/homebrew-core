class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/v2.3.0.tar.gz"
  sha256 "8a9b8aa58240bd3e8e74ea64598ea1df0ff0b84a1250e23649a2f55adbef1898"
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "2c926dd99efdc6701266ac03a1669e063b02e715e31f01cbb9bee4112332c491" => :high_sierra
    sha256 "601f0f768c63e5f3e437d8a82e38e2452c62dd5f0dcb2af81fcaf9181c249d86" => :sierra
    sha256 "d5146ae1dac85426ccfb3c128b90e0b7e438fd316cb25d60d4b57ffb1092649c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "expat"
  depends_on "pgrouting"
  depends_on "postgis"
  depends_on :postgresql
  depends_on "libpqxx"

  def install
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "RUNTIME DESTINATION \"/usr/bin\"",
              "RUNTIME DESTINATION \"#{bin}\""
      s.gsub! "set (SHARE_DIR \"/usr/share/osm2pgrouting\")",
              "set (SHARE_DIR \"#{pkgshare}\")"
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"osm2pgrouting", "--help"
  end
end

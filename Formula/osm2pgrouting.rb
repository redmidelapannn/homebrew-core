class Osm2pgrouting < Formula
  desc "Import OSM data into pgRouting database"
  homepage "http://pgrouting.org/docs/tools/osm2pgrouting.html"
  url "https://github.com/pgRouting/osm2pgrouting/archive/osm2pgrouting-2.0.0.tar.gz"
  sha256 "607e67b85664a40a495bfa37fdc236b617c3c6b41c3aa4fd68f780ba6a629469"
  revision 1
  head "https://github.com/pgRouting/osm2pgrouting.git"

  bottle do
    cellar :any
    sha256 "80ffb6284dd7d483668e4291b6599dcdd0ce0dd917f6643e4c13e2b6cdf89653" => :sierra
    sha256 "21e314db93f719c4135b66a61789d1668992d892925df036ff46b44274c77878" => :el_capitan
    sha256 "ff7e24936e3a229e4ccc132e01bf48d2d9c2f1db60c3e67a79e24a557f5c0535" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on :postgresql

  def install
    # Fixes the default hard-coded /usr/share which the program would be installed in.
    # Instead we supply relative paths, and run cmake with flag -DCMAKE_INSTALL_PREFIX=#{prefix} so that
    # we get a proper path inside prefix.
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "/usr/share/osm2pgrouting", "."
      s.gsub! "/usr/share/bin", "bin"
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/osm2pgrouting", 1)
  end
end

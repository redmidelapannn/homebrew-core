class OsmiumTool < Formula
  desc "Libosmium-based command-line tool for processing OpenStreetMap data"
  homepage "https://osmcode.org/osmium-tool/"
  url "https://github.com/osmcode/osmium-tool/archive/v1.8.0.tar.gz"
  sha256 "3e996ddcdedcfc3ac70dec3687d59a100dbfb04d00ed3f03df6b3e8d0bd92755"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5ce61f26dd7c6a29696e8efac750bb535b46ff1046c71015de1e02bd0c665b3c" => :high_sierra
    sha256 "7789d066c17a1909c363f6d71004ecb5c4c97b9d75f3fef3c46beed4bc52f6fc" => :sierra
    sha256 "c964c1118566a69d68cfd672f675989f2356a1aa0f39e055b9f015fe03b1468f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "boost"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1"/>
          <nd ref="2"/>
          <tag k="name" v="line"/>
        </way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role=""/>
          <member type="way" ref="1" role=""/>
        </relation>
      </osm>
    EOS
    output = shell_output("#{bin}/osmium fileinfo test.osm")
    assert_match /Compression.+generator=handwritten/m, output
    system bin/"osmium", "tags-filter", "test.osm", "w/name=line", "-f", "osm"
  end
end

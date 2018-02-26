class Osmfilter < Formula
  desc "Command-line tool to filter OpenStreetMap files for specific tags"
  homepage "https://wiki.openstreetmap.org/wiki/Osmfilter"
  url "https://gitlab.com/osm-c-tools/osmctools.git",
    :tag => "0.8", :revision => "fbf0a0a01624951efd7a7407ee3821fd817acf63"

  head "https://gitlab.com/osm-c-tools/osmctools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "379de6d75feb3d233e64403af8605310fce133bbaf4280ad36d0bc84b5c96bc4" => :high_sierra
    sha256 "fe5b798763fc7014f20a0d2b2c629eb62c6909ca79d8f7d28cf8e46bfc488724" => :sierra
    sha256 "434d360603b87aefe0dd90c29a951ce533bada09a1b276c7617658add1a98b9f" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  resource "pbf" do
    url "http://archive.osm-hr.org/albania/20120930-albania.osm.pbf"
    sha256 "f907f747e3363020f01e31235212e4376509bfa91b5177aeadccccfe4c97b524"
  end

  def install
    system "autoreconf", "-v", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("pbf").stage do
      system bin/"osmconvert", "20120930-albania.osm.pbf", "-o=test.o5m"
      system bin/"osmfilter", "test.o5m",
        "--drop-relations", "--drop-ways", "--drop-nodes"
    end
  end
end

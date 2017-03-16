class Osmfilter < Formula
  desc "Command-line tool to filter OpenStreetMap files for specific tags"
  homepage "https://wiki.openstreetmap.org/wiki/Osmfilter"
  url "https://gitlab.com/osm-c-tools/osmctools.git",
    :tag => "0.6", :revision => "7594309ea6f8437a04514f68cc36029cafa951fd"

  head "https://gitlab.com/osm-c-tools/osmctools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f69f72231d8403d5f388db775c0a1a291a53d9ab78af438e7a4e380f34e6c1a4" => :sierra
    sha256 "ad815a2fe50b7b5051fdd892fab741684afc4a16d0c132d4599e665c2fddd85a" => :el_capitan
    sha256 "ead2e0ca426b3732eb24965b44c1653294cc663cdb7c1a2f97711fd32360bb9a" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  resource "pbf" do
    url "http://data.osm-hr.org/albania/archive/20120930-albania.osm.pbf"
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

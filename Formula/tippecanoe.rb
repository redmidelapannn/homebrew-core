class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.24.1.tar.gz"
  sha256 "9caff598cec1863e51c1425429a4eaea113d2846f79b1d0538860388b00a3cd5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "97d8060663c746ff7f1e8e9d6bf6159e0933e930d50bc2b13cce015ecaa69318" => :sierra
    sha256 "3ade21bf75edc188d65cf8947c9237c45e6e9cb29657c8bc3c61d975bea3325a" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<-EOS.undent
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end

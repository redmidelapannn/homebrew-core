class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.10.0.tar.gz"
  sha256 "d11ddaf579c052dd4a15aaf873f537a1adc30f9e5aa043fead3277e51ce07412"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ba06bf7d7f4bea1640796842323ead1c5a932a8e9311c727bbbaf18a8fdde82" => :el_capitan
    sha256 "7deca978901e6211efc45e9689150c5e8251a745b1b5ea08a054a0f68bf9286b" => :yosemite
    sha256 "e4329dc870e0ee2e3f900a254d2e10e68d199b59c5dc86561f3717e7956707a1" => :mavericks
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
    assert File.exist?("#{testpath}/test.mbtiles"), "tippecanoe generated no output!"
  end
end

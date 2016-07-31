class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "fdb18bd5b0d7a6287f64eb11413f6994b43d974694b170f4d2df53d78e1d1e5b" => :el_capitan
    sha256 "e9111dd2313b23ec45b69b6651fbfb24a5688aabdff1538d76e530c63652ed84" => :yosemite
    sha256 "eed72283eb00abb00372e4bff17f9a05c8993d7adf4b857c37b76a9c562b9b0c" => :mavericks
  end

  depends_on "protobuf"

  def install
    cd "src" do
      system "make"
      lib.install "libosmpbf.a"
    end
    include.install Dir["include/*"]
  end
end

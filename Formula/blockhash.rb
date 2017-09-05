class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/0.2.1.tar.gz"
  sha256 "549e0f52e7a7545bae7eca801c64c79b95cbe9417975718e262fddaf78b00cca"
  revision 2
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8a7e2785238853d89676893d6762e603875e6303aa307361146189ce31a5b4f8" => :sierra
    sha256 "85a46407f22e93473bce8bbe74000853041ac7396608a65333273574d2f1fb2d" => :el_capitan
    sha256 "4a3f1637ecf1a6e9b1cddb854eb0c7981de4c27809eed9e2436d83fd1d7ee303" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"

  resource "testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("testdata").stage testpath
    hash = "00007ff07fe07fe07fe67ff07520600077fe601e7f5e000079fd40410001fffe"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end

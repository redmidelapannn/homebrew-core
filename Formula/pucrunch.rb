class Pucrunch < Formula
  desc "Hybrid LZ77 and RLE compressor"
  homepage "https://a1bert.kapsi.fi/Dev/pucrunch/"
  url "http://urchlay.naptime.net/~urchlay/src/pucrunch-20081122.tar.xz"
  version "1.14"
  sha256 "3488bfad58e2fac8f6c429c8727336dff7840d3c1dbf3131afd5380d77996d25"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c0cf87accf907eda2dfdfd9d8a6b489dd31b3aace7457833eb909cbeee7b68f" => :high_sierra
    sha256 "b2985a6753c25645d343140a9831b93c41782fa5a5b6f4bd2c98b69f8e1d7570" => :sierra
    sha256 "c47c937f1aecfb88f0cba3287e3da54f212c5139688e70b01ef86367601d04bf" => :el_capitan
  end

  def install
    system "make"
    bin.install "pucrunch"
  end

  test do
    code = [0x00, 0xc0, 0x4c, 0xe2, 0xfc]
    File.open(testpath/"a.prg", "wb") do |output|
      output.write [code.join].pack("H*")
    end

    system "#{bin}/pucrunch", "-c64", "a.prg", "b.prg"
  end
end

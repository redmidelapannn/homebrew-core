class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://stockfish.s3.amazonaws.com/stockfish-8-src.zip"
  sha256 "7bad36f21f649ab24f6d7786bbb1b74b3e4037f165f32e3d42d1ae19c8874ce9"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "362486cf7abffe823659bbfc2d898f182643ddcdca51bf8c31afe05141df8f68" => :sierra
    sha256 "362486cf7abffe823659bbfc2d898f182643ddcdca51bf8c31afe05141df8f68" => :el_capitan
    sha256 "20a4a619802b8b464abb16b8dd8be08e587600681fe1c1ab6c9610ee4cf01d7d" => :yosemite
  end

  def install
    if Hardware::CPU.features.include? :popcnt
      arch = "x86-64-modern"
    else
      arch = Hardware::CPU.ppc? ? "ppc" : "x86"
      arch += "-" + (MacOS.prefer_64_bit? ? "64" : "32")
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end

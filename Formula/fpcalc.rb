class Fpcalc < Formula
  desc "`fpcalc` tool from the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://github.com/acoustid/chromaprint/releases/download/v1.4.3/chromaprint-fpcalc-1.4.3-macos-x86_64.tar.gz"
  sha256 "159f3d0d8eb637d620f18251736917e54fda34d6bda42daf97ff5271fb78cb00"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b27487810dd0dd28dff7d67b9502fadc824ea0185b343b06d72dbaa5a2e957b" => :mojave
    sha256 "5b27487810dd0dd28dff7d67b9502fadc824ea0185b343b06d72dbaa5a2e957b" => :high_sierra
    sha256 "90049a570332a209ac7d08f51d959378bf7d7b496817e37e570bb26e60211e9d" => :sierra
  end

  def install
    bin.install "fpcalc"
  end

  test do
    system "#{bin}/fpcalc", "-version"
  end
end

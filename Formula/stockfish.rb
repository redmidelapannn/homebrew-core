class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/files/2629649/sf_10.zip"
  sha256 "9c2aa8b06935c930e80cba1426e10d76b6b1accc5a769e6bf1f41e15d79cadda"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4a18f998aea5ddea08a2f2f00e40413b349cee953ed2454af90497b6e7d12447" => :mojave
    sha256 "0575091cc96453264d87945b1d4a1dfc2ec726512c771fb5db5cbd62b7def859" => :high_sierra
    sha256 "0da9f83c69ea4eaea515bc2d4cb50797ae50672bef28dad183a4ec6552e45321" => :sierra
  end

  def install
    arch = if MacOS.version.requires_popcnt?
      "x86-64-modern"
    else
      "x86-64"
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end

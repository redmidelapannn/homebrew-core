class Alacritty < Formula
  desc "Cross-platform, GPU-accelerated terminal emulator"
  homepage "https://github.com/jwilm/alacritty"
  url "https://github.com/jwilm/alacritty/archive/v0.2.1.tar.gz"
  sha256 "d335f09ba914faf8d8b2ba91a67672aab3acd1a3bb1528ec3d9339381697f6a1"
  bottle do
    sha256 "621908112e8f28a46da070615652ba1cf5abdcd9d914db04e8074419c3af0d89" => :mojave
    sha256 "01a0c4225cafd5bc54fdd643c231a517f4ebfc91016abc87fe0076a7275b62cc" => :high_sierra
    sha256 "c7a3b4670c5e125ed6aff3313e0d9fea8528021681a4bd08dd7f224f70ba4745" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "make", "app"
    bin.install "target/release/osx/Alacritty.app/Contents/MacOS/alacritty"
  end

  test do
    system "#{bin}/alacritty", "-V"
  end
end

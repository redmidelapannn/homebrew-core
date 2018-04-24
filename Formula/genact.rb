class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/0.4.0.tar.gz"
  sha256 "92265af4fc7adceda4379336ec5440125b60556dca59f16de37bfb32c35c5da8"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/genact"
  end

  test do
    system "#{bin}/genact", "-V"
  end
end

class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.3.11.tar.gz"
  sha256 "2ded5cbb140955e87e0edee5c9728146316a34fa0a23a4de1f7a28df569b25d0"

  bottle do
    rebuild 1
    sha256 "c56c1bb9f616ff5ee9c9af6272035e6c742228d9a91ea23e8410322f192cf7be" => :high_sierra
    sha256 "cb30c1a71e711fb5e73719d705be54d814769a7bb8bd2f672ca8d765d2eb0c4c" => :sierra
    sha256 "45e900e36227d3c8ffb2c8f39dcc6efb9e59a10b70772640bcaca32adea9ec97" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end

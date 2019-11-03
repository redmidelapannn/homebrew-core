class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.4.tar.gz"
  sha256 "5bb6671ce38957352b28a428c5bab26eff2c2fe2faf9c961ebdfb16d8f63cad6"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a30f6b6cfdab21355b1fbeae7b2d842a9aacb6b09ab7d98842eb472e4e36b73c" => :catalina
    sha256 "2ca3b47683a7fc7a286c2f153de416fd6bd053fc2ec072cf5ca619200eac76c5" => :mojave
    sha256 "1ab551ae6cfdc4746e30776c903e5d927f680076b852bce3412000c2d7bb63c2" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end

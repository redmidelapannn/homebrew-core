class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.3.tar.gz"
  sha256 "4e8e3cb01e1d5be96f971296b19c8f5cca2159b2f438f735db6ff90572b272d3"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2a845815d33e918a81cbe6d4924b9b8400ba10cc601b9a0e842f3e8ea300ce3" => :catalina
    sha256 "1bd6809ec88a2a49288b14e797a75598bd339655b95a07883d2551131266498c" => :mojave
    sha256 "2e4213e46ce5b0f0fd9912632a06e97939deddc49a8c2c9ba9d9c4a2db7be2d8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end

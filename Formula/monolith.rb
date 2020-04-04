class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.1.tar.gz"
  sha256 "bdd012c8341267a92345561bd48a4b3f246bf59aab50a14e5648c4b8974f6995"

  bottle do
    cellar :any_skip_relocation
    sha256 "72693102aa67bdce6aeb94f464033804b16c25e7730b574ef0f1fd3926941471" => :catalina
    sha256 "1a0c67382e5586d118f6cbb3ac013afe4ce74c77c71f3cd86c730fe840a11b3b" => :mojave
    sha256 "768e0ac9a332a75a6848e9baba101e2d6624380407682bd8caa4d4df0a021398" => :high_sierra
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

class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.2.2.tar.gz"
  sha256 "224ef6cc7fbde12b3d0d6f0b6758ada40848423e707af0a0b943bac3834a4754"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d36b7e7dcc2b843c725292e7ce295ab10bdaed1390c77287f7620357591168a" => :catalina
    sha256 "124754304e25b051e0627858ec0c1b4eab4742da21bf55d5cfd4775d72ae5716" => :mojave
    sha256 "b290c5fbd56f5cf0cf00b6d90f20090057801e1f8c61d9c1d5dab8c4aef4ade4" => :high_sierra
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

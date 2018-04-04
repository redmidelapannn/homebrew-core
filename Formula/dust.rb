class Dust < Formula
  desc "More intuitive version of du in rust. Similar to ncdu"
  homepage "https://github.com/bootandy/dust/"
  url "https://github.com/bootandy/dust/archive/v0.2.1.tar.gz"
  sha256 "ea597ad1fa36b1e05fc74b0b98d89e53e79f9d420959de8eadb0e8d05587e265"
  head "https://github.com/bootandy/dust.git"

  bottle do
    sha256 "7d2ad5235867a531518215be445d3933bf14603e56d9fce4141f728974539757" => :high_sierra
    sha256 "610eb7669d52944d25686ebb043fb7a908e30ca014072576acd9494a421bd8a6" => :sierra
    sha256 "463deb5da7eb3983e706cfd0e70cbc5139c22ce3e8675858fc43ea8ef2a1bb4e" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/dust"
  end

  test do
    system "#{bin}/dust"
  end
end

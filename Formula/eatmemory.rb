class Eatmemory < Formula
  desc "Simple C program to allocate memory from the command-line"
  homepage "https://github.com/julman99/eatmemory"
  url "https://github.com/julman99/eatmemory/archive/v0.1.6.tar.gz"
  sha256 "5f49eadc5462cebb01afec02caa2729d9885e0f0a251399d1e8f62a726cc0a9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a367a410327d00f044e6c61a45d5c8347c821ed0ce7621ac111ffba768b5431" => :sierra
    sha256 "adeaeaf61cc45acfb2234f4c1cc05ca4543e49bed2f2541381d3ccc1559231c5" => :el_capitan
    sha256 "d7dc49b0c08c137d69437f1e63cb292c63ff0c096aa99a4f3f50d84cc821ac52" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/eatmemory", "-?"
  end
end

class Zpm < Formula
  desc "zsh plugin manager in ansi C"
  homepage "https://github.com/zpm-project/zpm-zsh"
  url "https://github.com/zpm-project/zpm-zsh/archive/v0.1.0.tar.gz"
  sha256 "113ec66a7fc292133146018b74e050b924d5dfa31741e4da14995b3fed641a18"
  head "https://github.com/zpm-project/zpm-zsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e1c99507da4f002c912632972f260efd406b7e4e45c0a6cf8a2f181623a7973" => :sierra
    sha256 "eb35fe93663c42a484ef034008e0efefac97e8e244de71e4c0f5375472575ff4" => :el_capitan
    sha256 "75cd1b95d7cfb024939d4683e0819711d5a09c49c90e883e7454e9cd59fdf430" => :yosemite
  end

  resource "url.h" do
    url "https://github.com/jwerle/url.h/archive/a65623ad107be19ca4efb5a36379f3440eb48091.tar.gz"
    sha256 "4b454091653b811a0a09c7b4a43c9644daa4f3806c586d6f3c497b58cb9b6953"
  end

  def install
    resource("url.h").stage do
      cp "url.h", "#{buildpath}/url.h/"
    end

    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "make", "test"
  end
end

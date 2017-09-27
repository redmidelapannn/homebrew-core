class Habitus < Formula
  desc "A Build Flow Tool for Docker"
  homepage "http://www.habitus.io"
  url "https://github.com/cloud66/habitus/releases/download/1.0.1/habitus_darwin_amd64"
  version "1.0.1"
  sha256 "b12f3b2d6def75287d9b9e699bab0b4f231f8fe272e21bd359ab5b1bb5628458"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8b92aabe4492b47ebfb584ed7b87e1bedc8b8f8019219b3fec1405465e9df96" => :high_sierra
    sha256 "d8b92aabe4492b47ebfb584ed7b87e1bedc8b8f8019219b3fec1405465e9df96" => :sierra
    sha256 "d8b92aabe4492b47ebfb584ed7b87e1bedc8b8f8019219b3fec1405465e9df96" => :el_capitan
  end

  def install
    mkdir_p bin
    cp "./habitus_darwin_amd64", "#{bin}/habitus"
    chmod "a+x", "#{bin}/habitus"
  end

  test do
    system "#{bin}/habitus", "--version"
  end
end

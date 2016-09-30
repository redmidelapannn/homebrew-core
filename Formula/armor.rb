class Armor < Formula
  desc "Simple HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.1.1.tar.gz"
  sha256 "1772c99dd16cb4cc05c27f34382c33c5ff60aa0f4703ad25d7d6127f2d0b745d"
  head "https://github.com/labstack/armor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c258bc9445a08cdb7ba744a2eccfa86f0522c701d27211193d49806aad32d8c" => :sierra
    sha256 "761823f6135acee0d1a99c1b11b06902804a62bbcc4706506024fede038042ce" => :el_capitan
    sha256 "c2ee4294f3f082d9ed3abe99271949b6bcb9825eaa715d3e60d14372fb348051" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
    end
  end

  test do
    system "armor", "-v"
  end
end

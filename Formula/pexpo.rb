require "formula"

class Pexpo < Formula
  homepage "https://github.com/nnao45/pexpo"
  url "https://github.com/nnao45/pexpo/archive/1.32.tar.gz"
  sha256 "764f08c054d8c2b8f5b0f895917afb018b640b70cce6210a1141e998843548fd"
  head "https://github.com/nnao45/pexpo.git"
  version "1.32"

  bottle do
    cellar :any_skip_relocation
    sha256 "672618397bbb446b8ab1fa6207bb5866d2d7352ba193c9d41fc190442c121af3" => :high_sierra
    sha256 "898524f3dafbb89d3e8435b1bb0412f586f01e9bc2ed6191997e1ddb3bb0aa23" => :sierra
    sha256 "901dca9460ab486a25410702d4a21e9ff3b345050f0816b46e650e841db3d66f" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :hg => :build
  
  def install
    ENV["GOPATH"] = buildpath
    
    # Install Go dependencies
    system "go", "get", "github.com/dariubs/percent"
    system "go", "get", "github.com/mattn/go-runewidth"
    system "go", "get", "github.com/nsf/termbox-go"
    system "go", "get", "github.com/tatsushid/go-fastping"
	  
    # Build and install termshare
    system "go", "build", "-o", "pexpo"
    bin.install "pexpo"
  end
end

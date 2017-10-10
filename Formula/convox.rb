class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171007002353.tar.gz"
  sha256 "ad9212d7f08edf890433b0c6c4a5359ddb05c7527fd1d2b1d5d9b54f54ecf396"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc4fcf93db630b72fa7e432a98eda35dd1a26166d382edaac384a18dc3b74866" => :high_sierra
    sha256 "2bff94acf352a0fa7df323992a5dff5a3b8b5cf61669450366b18d3c8682708b" => :sierra
    sha256 "35c7ecc77876c8be4821c0bbdc4d183598fc308b560ad7b36eeb3f4c59f15c12" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end

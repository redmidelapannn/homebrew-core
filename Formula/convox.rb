class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170404185653.tar.gz"
  sha256 "a89c5926eb4e654fd3d764012db5b4e3574828ab1294fc68580bcb690ca19026"

  bottle do
    sha256 "f6ff5c0c5d0e8222a20b6d090576312fb43656e6bc39e49ea5f225eb4ed18f23" => :sierra
    sha256 "3e1f6ba607aa73ab62b7159cca22e2666ca16c50295debdb36019c3596bb36a0" => :el_capitan
    sha256 "365a0417053f18adcf6faf0e416c7f4afb18a34966509a483e946546028930c7" => :yosemite
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

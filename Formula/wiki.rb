require "language/go"

class Wiki < Formula
  desc "Fetch summaries from MediaWiki wikis, like Wikipedia"
  homepage "https://github.com/walle/wiki"
  url "https://github.com/walle/wiki/archive/1.3.0.tar.gz"
  sha256 "c12edcaed5c9d5e69fc43e77713a68948a399017467d248ba59367b5d458a9e6"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "b3527f72459d30f111c25e6b6e07dc1d7a6df5ef724ecbd20d0fc0ce7bf6eac6" => :el_capitan
    sha256 "64fcd8e7c1f337228b8c25bdcbcb069865ecd81bad4cbefc62f9e8d89bea57e8" => :yosemite
    sha256 "3a0474ce658c11d2872df96f4259adc9489edb7da1a721fe3e47bee5e41bec1e" => :mavericks
  end

  depends_on "go" => :build

  conflicts_with "osxutils", :because => "both install `wiki` binaries"

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
      :revision => "40e4aedc8fabf8c23e040057540867186712faa5"
  end

  def install
    ENV["GOPATH"] = buildpath
    wikipath = buildpath/"src/github.com/walle/wiki"
    wikipath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/walle/wiki" do
      system "go", "build", "-o", "build/wiki", "cmd/wiki/main.go"
      bin.install "build/wiki"
      man1.install "_doc/wiki.1"
    end
  end

  test do
    assert_match "Read more: https://en.wikipedia.org/wiki/Go", shell_output("#{bin}/wiki golang")
  end
end

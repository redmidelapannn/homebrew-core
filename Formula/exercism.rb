require "language/go"

class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.3.0.tar.gz"
  sha256 "ca1432af80f9257c4c06107d0d1732845d49ac450f56ea04bcf58ead46d0af74"
  head "https://github.com/exercism.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3feda5638428ae82993a65867b913b0eaa6bb8b4322f7121cb13e18f8f1bfb8b" => :el_capitan
    sha256 "2aed1a3f9a3ed080829acadf17961d076caf5f5d4001d8b686df9da01c84c2ca" => :yosemite
    sha256 "e73b00497d511338a88cf97181b6120327c6d7fd52c4e10f57291d7fd28a6513" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "bca61c476e3c752594983e4c9bcd5f62fb09f157"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
      :revision => "6e7f843663477789fac7c02def0d0909e969b4e5"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
      :revision => "d9558e5c97f85372afee28cf2b6059d7d3818919"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
      :revision => "3eb7007b740b66a77f3c85f2660a0240b284115a"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/exercism/cli"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "go", "build", "./exercism/main.go"
    end

    bin.install path/"main" => "exercism"
  end

  test do
    assert_equal "exercism version #{version}",
      shell_output("#{bin}/exercism --version").strip
  end
end

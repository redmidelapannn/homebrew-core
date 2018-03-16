require "language/go"

class SlackAdvancedExporter < Formula
  desc "Exports additional data from Slack"
  homepage "https://github.com/grundleborg/slack-advanced-exporter"
  url "https://github.com/grundleborg/slack-advanced-exporter/archive/v0.2.0.tar.gz"
  sha256 "7aaf68249512a8000ae969742aeaad77bea3997915e35187a0c45f7d69728fdc"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f270dabcba219961b6f555043c880d39d19556845e19bf1b086db82255b7674" => :high_sierra
    sha256 "0a8d7154ddff40520c9f871ea2e72b7e9754f99a51f91b32bfef8ae72bc66c15" => :sierra
    sha256 "c578bf62afbdea4586be8b43bbafea06e327ef7baceb6f767a078efe2bbb5511" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "gopkg.in/urfave/cli.v1" do
    url "https://github.com/urfave/cli.git",
        :revision => "cfb38830724cc34fedffe9a2a29fb54fa9169cd1"
  end

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/grundleborg/slack-advanced-exporter"
    bin_path.install Dir["{*,.git}"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd bin_path do
      system "go", "build", "-o", bin / "slack-advanced-exporter", "."
    end
  end

  test do
    assert_match "Slack Advanced Exporter version 0.2.0", shell_output("#{bin}/slack-advanced-exporter -v 2>&1", 2)
  end
end

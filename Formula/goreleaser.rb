class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.77.1.tar.gz"
  sha256 "ee4788a44c1f5700188d1933d42f9637b682cce54333d3c5d267564d614f44c3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "072619b6e70c42cbb5899dfa7ca6655f9b8b4a0c2b76b0e461b7b2d640398521" => :high_sierra
    sha256 "038082090d0b46754ad6303762ece0346efd5d462601cffdb6701bb4e109e1f7" => :sierra
    sha256 "19bc013d245d3468c104cf18ead79ef0c87172d8b3a48d2cea5d5dfa9c1e4fc1" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o",
             bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

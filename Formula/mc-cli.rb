require "language/go"

class McCli < Formula
  desc "CLI for setting up and controlling Minecraft servers."
  homepage "https://mc-cli.hexagonminecraft.com/"
  url "https://github.com/HexagonMinecraft/mc-cli/archive/0.0.3.tar.gz"
  sha256 "ad75949dbe8bb1f1e55ff91377fec5a10e7bea4d42cdd23235e2e72195e9faba"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fe52333cead34f26e9878464c286c99b943e676855dd81fdeea44a54b590280" => :sierra
    sha256 "0c0d804803859aadce2488b25e0c35b554b14343f7af6f8544e5e6033b1bd728" => :el_capitan
    sha256 "578018f68db30bd2dd1653277ac47db3f750e544da22249b5ba48d95d90a1d98" => :yosemite
  end

  depends_on "go" => :build
  go_resource "github.com/Masterminds/semver" do
    url "https://github.com/Masterminds/semver.git",
        :revision => "abff1900528dbdaf6f3f5aa92c398be1eaf2a9f7"
  end

  go_resource "github.com/briandowns/spinner" do
    url "https://github.com/briandowns/spinner.git",
        :revision => "fb621c2fd72fdd729f857e6d9c3a990e43fef910"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "d70f47eeca3afd795160003bc6e28b001d60c67c"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/hexagonminecraft"
    ln_s buildpath, "src/github.com/hexagonminecraft/mc-cli"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"mc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mc -v")
  end
end

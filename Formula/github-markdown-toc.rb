require "language/go"

class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/0.7.0.tar.gz"
  sha256 "826b894e3890a044ac8d8601b4b27545d03f552d3639059d6746d9e56f8f9d1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d221a575b49bcdc4991c21f028ec9f0d25036a23514ccef1e75a77d6c9932ee" => :sierra
    sha256 "91d5c53b62cf57d01e4b0456744f455745cb0ff825496c0022fc948130b2015a" => :el_capitan
    sha256 "2f6928e1c6ce15906f9019dc0fbe23fc20d191da3dea3ae07d43c60e745cf6a5" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
        :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
        :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://github.com/alecthomas/kingpin.git",
        :revision => "v2.1.11"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ekalinin/"
    ln_sf buildpath, buildpath/"src/github.com/ekalinin/github-markdown-toc.go"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "gh-md-toc", "main.go"
    bin.install "gh-md-toc"
  end

  test do
    system bin/"gh-md-toc", "--version"
    system bin/"gh-md-toc", "../README.md"
  end
end

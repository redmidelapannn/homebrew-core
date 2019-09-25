class GithubMarkdownToc < Formula
  desc "Easy TOC creation for GitHub README.md (in go)"
  homepage "https://github.com/ekalinin/github-markdown-toc.go"
  url "https://github.com/ekalinin/github-markdown-toc.go/archive/1.0.0.tar.gz"
  sha256 "0a13627a29114ee817160ecd3eba130c05f95c4aeedb9d0805d8b5a587fce55a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "74909a391fb98a5f94034ae46779f6fc37ba3dbed051f4b04bdd88c32784538b" => :mojave
    sha256 "4f6a326088dd5af6518b16c2a695a880aa8d7652eb2d0aecb202e9a9fb886a22" => :high_sierra
    sha256 "a8ad3d9ad0a4d6252ebace2c3c2ab7351c90f10f0a7870df1f5bd8fc535bbb5b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ekalinin/github-markdown-toc.go"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"gh-md-toc"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"README.md").write("# Header")
    system bin/"gh-md-toc", "--version"
    assert_match "* [Header](#header)", shell_output("#{bin}/gh-md-toc ./README.md")
  end
end

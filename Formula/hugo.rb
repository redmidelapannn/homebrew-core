class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.63.0.tar.gz"
  sha256 "3a1f07bc3a3b5458c34cf45fd2bd8c06ded6c749ff66e4d5247a9170df2f00ff"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "387b803846f349b364a21d46c771ba66f8dd6cd89aa9096ab641ff00de41a493" => :catalina
    sha256 "d28d949c7668fdca3a4530528a0a8290a2f493ca8bb1474b92d24fa8fec8ab43" => :mojave
    sha256 "0758fd5f511531e2c1a6d771a4dfe3bd19e1cbc06b04b375bfa8c65650e5df04" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children

    cd "src/github.com/gohugoio/hugo" do
      system "go", "build", "-o", bin/"hugo", "-tags", "extended", "main.go"

      # Build bash completion
      system bin/"hugo", "gen", "autocomplete", "--completionfile=hugo.sh"
      bash_completion.install "hugo.sh"

      # Build man pages; target dir man/ is hardcoded :(
      (Pathname.pwd/"man").mkpath
      system bin/"hugo", "gen", "man"
      man1.install Dir["man/*.1"]

      prefix.install_metafiles
    end
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end

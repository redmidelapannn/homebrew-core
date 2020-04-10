class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.69.0.tar.gz"
  sha256 "b4db7bf58c9cc722bf1fd70265ce97a743ed720990f22401673f2b612d7c44ec"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "125f66fa82de8e338fed45487e5772fe941cf03247434039dce2469bbfbc0b28" => :catalina
    sha256 "84fd8f703bea270e8238805a38972934f40f7f57e3798d4274ec4f85939573a3" => :mojave
    sha256 "04027cb2b0ed23ca51c675bdabd87c08ffe76c2697edfebbe4fd71c729b1155a" => :high_sierra
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

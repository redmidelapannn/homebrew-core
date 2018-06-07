class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.41.tar.gz"
  sha256 "a5a435d352ad8df3f0dd77968e6ac21925ee006e5538a37f775d9f53b30799fc"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ea1bd8cf85e1efe0081db7112019293afa41f2ca471fbb13973aa35e82fba46d" => :high_sierra
    sha256 "2d8126486fb33e095bd64688e95ef05866644a9ff4debc0e514e69b056ba6103" => :sierra
    sha256 "9882b48a104045369c7aaa79e1fb29d6caf8fb2a3a209a4ca22f93e53d292beb" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"hugo", "main.go"

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

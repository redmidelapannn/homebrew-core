class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.20.6.tar.gz"
  sha256 "692e08b009430d27064821d498f1454152cbfd5f26d019c29002e6fbff8fc387"
  head "https://github.com/spf13/hugo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "22e27f4c4e588b7c1c5d68d03a4dd834f6349cd45b80b0ce2763ae00864d438d" => :sierra
    sha256 "60c0a396f4d52f6ee8df2f2fa3cd0d5590bac954cbfdc4d63bd81664827c886b" => :el_capitan
    sha256 "09b29886ca13f44963322c69f8d61de4eaf328bad286dcea85903c90b39dce28" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/spf13/hugo").install buildpath.children
    cd "src/github.com/spf13/hugo" do
      system "govendor", "sync"
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
    assert File.exist?("#{site}/config.toml")
  end
end

class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.40.1.tar.gz"
  sha256 "060d402cb4f4e007ea6366c74d97a738c236385d77a7e2585f885bd0a97a843e"
  head "https://github.com/gohugoio/hugo.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a4b305e3170d4724ac18bf9ae3d5833cd144e126d453441201a348da1d41eeb6" => :high_sierra
    sha256 "f5f7f5c2bbe0220c85aa77aad25c12feaaf5a808bfb19f3c52287cc5d2beddf5" => :sierra
    sha256 "347122af022655519e1556e405928cdbd45311cb3985663dfd71f69fd38354f8" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    cmd = [HOMEBREW_BREW_FILE, "log", "-1", "--format=%cd", "--date=format:%Y-%m-%dT%H:%M:%S%z", "hugo"]
    build_date = IO.popen(cmd, :err=>"/dev/null").read.chomp
    puts "Setting BuildDate to Formula/hugo.rb commit date: #{build_date}"
    ldflags = "-X github.com/gohugoio/hugo/hugolib.BuildDate=#{build_date}"

    (buildpath/"src/github.com/gohugoio/hugo").install buildpath.children
    cd "src/github.com/gohugoio/hugo" do
      system "dep", "ensure"
      system "go", "build", "-ldflags", ldflags, "-o", bin/"hugo", "main.go"

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

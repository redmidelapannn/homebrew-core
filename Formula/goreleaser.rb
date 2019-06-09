class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser/archive/v0.109.0.tar.gz"
  sha256 "ec48ff424ce1b35144f0fbad22e74029bfe657b3582309a0a198ff74f34afa96"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e8a6d46e2f1a45162524a8bb4c9f8f392165db8f347416f21d8e9e0178cb844" => :mojave
    sha256 "86d1e2e887df622c54ce627f40a3d225965a2976010201b0e5f0cb51153ca65d" => :high_sierra
    sha256 "11c9013eb56b8ac91b14f2c1942501fdfcf13ffa2e1ec5dfd8562a6a38acaace" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/goreleaser/goreleaser").install buildpath.children
    cd "src/github.com/goreleaser/goreleaser" do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
                   "-o", bin/"goreleaser"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end

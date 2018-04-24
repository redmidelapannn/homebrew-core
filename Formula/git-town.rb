class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/Originate/git-town/archive/v7.1.1.tar.gz"
  sha256 "55cebd4723170bc0df65ca76c34ba88d7d67c18240dd25569ade3ccbd0cf8bf3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ca9404a44fd26180d97ba68f8c085e5c099120756ba39cfe36f17d81c5c2c671" => :high_sierra
    sha256 "248724887e128fd7b8a175156ee2e49a480db4e3c9fa54afe3229dad7528b3d4" => :sierra
    sha256 "aae301015c738931dd4c623345aa42f466a9f2363bd6aa67e175226ccac6fcb9" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :macos => :el_capitan

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Originate").mkpath
    ln_sf buildpath, buildpath/"src/github.com/Originate/git-town"
    system "go", "build", "-o", bin/"git-town"
  end

  test do
    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end

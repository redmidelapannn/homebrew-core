class GitFilterRepo < Formula
  desc "Quickly rewrite git repository history"
  homepage "https://github.com/newren/git-filter-repo"
  url "https://github.com/newren/git-filter-repo/releases/download/v2.25.0/git-filter-repo-2.25.0.tar.xz"
  sha256 "ea8cdb7dca68111e819d141fc4d302b811c1e5362c12de7403882ba9908be29c"

  bottle do
    cellar :any_skip_relocation
    sha256 "38ec75c722d85c6559ab99dff1d6c4d12e9d4ea315701cdd7a1dc9bb63eb55d1" => :catalina
    sha256 "7d0f5be14f42a60e88c856278954d1b93fbd228ba9bf24d38a86ea6891c615ee" => :mojave
    sha256 "7d0f5be14f42a60e88c856278954d1b93fbd228ba9bf24d38a86ea6891c615ee" => :high_sierra
  end

  # ignore git dependency audit:
  #  * Don't use git as a dependency (it's always available)
  # But we require Git 2.22.0+
  # https://github.com/Homebrew/homebrew-core/pull/46550#issuecomment-563229479
  depends_on "git"

  # Use any python3 version available
  # https://github.com/Homebrew/homebrew-core/pull/46550/files#r363751231
  if MacOS.version >= :catalina
    uses_from_macos "python3"
  else
    depends_on "python3"
  end

  def install
    bin.install "git-filter-repo"
    man1.install "Documentation/man1/git-filter-repo.1"
  end

  test do
    system "#{bin}/git-filter-repo", "--version"

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@example.com"

    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "foo"
    # Use --force to accept non-fresh clone run:
    # Aborting: Refusing to overwrite repo history since this does not look like a fresh clone.
    # (expected freshly packed repo)
    system "#{bin}/git-filter-repo", "--path-rename=foo:bar", "--force"

    assert_predicate testpath/"bar", :exist?
  end
end

class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.4.2.tar.gz"
  sha256 "130a552a27c8f324ac0548baf9db0519c4ae96c26a85f926c07ebe0f15a69fc2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4dc77371d981e66943ab43d0d024102af2e52db380bdb069c553e19b2b2790e8" => :high_sierra
    sha256 "c72b6f3a12164d810824b9098a824cba88dd3485db1dc22569eaf263b248a704" => :sierra
    sha256 "a68774d390d4be94cacfe14c2fd9fc9ed483a2b92bb635e8441fa93b147d7d94" => :el_capitan
  end

  depends_on "go" => :build

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    begin
      deleted = ENV.delete "SDKROOT"
      ENV["GEM_HOME"] = buildpath/"gem_home"
      system "gem", "install", "ronn"
      ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    ensure
      ENV["SDKROOT"] = deleted
    end

    system "./script/bootstrap"
    system "./script/man"

    bin.install "bin/git-lfs"
    man1.install Dir["man/*.1"]
    doc.install Dir["man/*.html"]
  end

  def caveats; <<~EOS
    Update your git config to finish installation:

      # Update global git config
      $ git lfs install

      # Update system git config
      $ git lfs install --system
  EOS
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end

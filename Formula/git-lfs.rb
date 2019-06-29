class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/releases/download/v2.7.2/git-lfs-v2.7.2.tar.gz"
  sha256 "1e0a11e16051ea32127787a9197edd02564a5e4452f0e99d0d0b62ccfe22fc22"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "91b933354a4489f4621a5cda38601e60201b3d65cbe6b7d57e8b7be6be8fd68f" => :mojave
    sha256 "16325bcec8ad45bb0d8dceed0681ced9778395f948e979f938a3f847e54b3121" => :high_sierra
    sha256 "51a76cfb1ba014b155ef4c9d7ee0c36e3c7071e56da73f8e70b91930c0b10243" => :sierra
  end

  depends_on "go" => :build
  uses_from_macos "ruby"

  # System Ruby uses old TLS versions no longer supported by RubyGems.
  depends_on "ruby" => :build if MacOS.version <= :sierra

  def install
    ENV["GIT_LFS_SHA"] = ""
    ENV["VERSION"] = version

    (buildpath/"src/github.com/git-lfs/git-lfs").install buildpath.children
    cd "src/github.com/git-lfs/git-lfs" do
      ENV["GEM_HOME"] = ".gem_home"
      system "gem", "install", "ronn"

      system "make", "vendor"
      system "make"
      system "make", "man", "RONN=.gem_home/bin/ronn"

      bin.install "bin/git-lfs"
      man1.install Dir["man/*.1"]
      man5.install Dir["man/*.5"]
      doc.install Dir["man/*.html"]
    end
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

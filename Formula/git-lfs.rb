class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/git-lfs/git-lfs"
  url "https://github.com/git-lfs/git-lfs/archive/v2.3.0.tar.gz"
  sha256 "4f972b4578d09a464cfc730df3a0ff6255d5ca0e09ea2913b3b6515d9c987d81"

  bottle do
    cellar :any_skip_relocation
    sha256 "2263b32bad83fbef671a626c73011d5d149d766e9926eaa7488039a6f9950440" => :sierra
    sha256 "f10ed83d4dc944cfe6a71638c9d4a0eef7492c34b028487fb406f58d9c51c128" => :el_capitan
  end

  depends_on "go" => :build

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

  def caveats; <<-EOS.undent
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

class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  revision 1
  head "https://github.com/glandium/git-cinnabar.git"

  stable do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.4.0",
        :revision => "6d374888ff0287517084c0ec7573963961f6acec"

    # 5 Nov 2017 "Support the batch API change from mercurial 4.4"
    patch do
      url "https://github.com/glandium/git-cinnabar/commit/7ea77b0.patch?full_index=1"
      sha256 "e28fdf1b9afa94dbd17289e739cd68af34bf7ae708b827cfa9e23286dbbbb57c"
    end

    # 5 Nov 2017 "Adapt localpeer to sshpeer changes in mercurial 4.4"
    # Backport of https://github.com/glandium/git-cinnabar/commit/5c59ae1
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e56093e/git-cinnabar/mercurial-4.4-sshpeer.patch"
      sha256 "9af333567ff4aec002c947906d9e5a62ce7358c4ffa1edf7be0b5fe0a96b87ae"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f27d3ca476fce9232aea17f7814c8e4f263b0c2d46b7dcfb7a1a60c2d60010b4" => :high_sierra
    sha256 "eff068f28f320a3c70ad092d5eae0ac6ce460bcd5605338253d0b8470119f673" => :sierra
    sha256 "3078649a06ad0addb0d74a6bcb32e9fa91941b3b559a051b7845a79f473854df" => :el_capitan
  end

  devel do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.5.0b3",
        :revision => "e47124aa510a3b01409c260c2659666d885ae62f"
    version "0.5.0b3"
  end

  depends_on "mercurial"

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end

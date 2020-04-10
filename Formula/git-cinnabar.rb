class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.4.tar.gz"
  sha256 "11980dc0d4d7a291930e4c7f7f4a3f2086fac0f0c9d7cd1dee0292cb0e245010"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "08f2e10e0cb058628d183630d09ca0c6256542b7d70c8ff930422190596fbdfd" => :catalina
    sha256 "bb7e9c846436d4e40da3c426499b05dcf0943cbea745b0506cfa7a5330136427" => :mojave
    sha256 "5e365c1e6493a6d6e1c375f4b88d08dc3adabdae8e475e542bd5423a7676c6fc" => :high_sierra
  end

  depends_on :macos # Due to Python 2
  depends_on "mercurial"

  uses_from_macos "curl"

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

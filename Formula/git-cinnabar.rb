class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.1.tar.gz"
  sha256 "f2ade7c0b5d362eb4b9e51ca4faa7a8a200f08a62a7104c0d61cab1f6ea18b09"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8caede121a99973b8b1e1c398fbdbf1ae2b2ea78149f431068384510e065e880" => :mojave
    sha256 "e9744cb8526803342735aaffe9012787b6683e46e7c0664b7139375861374600" => :high_sierra
    sha256 "9d6219c307f717c16f8ebaee6d5966b3db2fcb863add206ce402f71589b96a21" => :sierra
  end

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

class GitRemoteHg < Formula
  desc "Transparent bidirectional bridge between Git and Mercurial"
  homepage "https://github.com/felipec/git-remote-hg"
  url "https://github.com/felipec/git-remote-hg/archive/v0.3.tar.gz"
  sha256 "2dc889b641d72f5a73c4c7d5df3b8ea788e75a7ce80f5884a7a8d2e099287dce"
  head "https://github.com/felipec/git-remote-hg.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "af25fb5d1fdfe1ac4d884df2c0850d296223961ec3c7a9f74e0555b7f253ce34" => :el_capitan
    sha256 "ba4093f86dbbf5c770ccab13a0f94fe1ed11727e72fde031f01b5e9a49a5542b" => :yosemite
    sha256 "ba4093f86dbbf5c770ccab13a0f94fe1ed11727e72fde031f01b5e9a49a5542b" => :mavericks
  end

  depends_on :hg
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    inreplace "git-remote-hg", "python2", "python"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
  end
end

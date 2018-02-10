class GitMultipush < Formula
  desc "Push a branch to multiple remotes in one command"
  homepage "https://github.com/gavinbeatty/git-multipush"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/git-multipush/git-multipush-2.3.tar.bz2"
  sha256 "1f3b51e84310673045c3240048b44dd415a8a70568f365b6b48e7970afdafb67"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef2038acfbd4233b9c5b5811d34619ec72281a2852b93bbd263dbed31c50685d" => :high_sierra
    sha256 "ef2038acfbd4233b9c5b5811d34619ec72281a2852b93bbd263dbed31c50685d" => :sierra
    sha256 "ef2038acfbd4233b9c5b5811d34619ec72281a2852b93bbd263dbed31c50685d" => :el_capitan
  end

  devel do
    url "https://github.com/gavinbeatty/git-multipush/archive/git-multipush-v2.4.rc2.tar.gz"
    sha256 "999d9304f322c1b97d150c96be64ecde30980f97eaaa9d66f365b8b11894c46d"
  end

  def install
    # Devel tarballs don't have versions marked, maybe due to GitHub release process
    # https://github.com/gavinbeatty/git-multipush/issues/1
    (buildpath/"release").write "VERSION = #{version}" if build.devel?
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    # git-multipush will error even on --version if not in a repo
    system "git", "init"
    assert_match version.to_s, shell_output("#{bin}/git-multipush --version")
  end
end

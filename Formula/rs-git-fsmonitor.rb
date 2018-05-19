class RsGitFsmonitor < Formula
  desc "Git fsmonitor hook written in Rust"
  homepage "https://github.com/jgavris/rs-git-fsmonitor"

  url "https://github.com/jgavris/rs-git-fsmonitor/releases/download/v0.1.0/rs-git-fsmonitor"
  sha256 "4faf1723ea75a76e0dd6187d5a3e9074fd5e93dd13f1024843d4ed256ff689e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1830192aaf05bc24df1514c88cf5bf639bdef831884db0d61827fa8d17765cf" => :high_sierra
    sha256 "d1830192aaf05bc24df1514c88cf5bf639bdef831884db0d61827fa8d17765cf" => :sierra
    sha256 "d1830192aaf05bc24df1514c88cf5bf639bdef831884db0d61827fa8d17765cf" => :el_capitan
  end

  depends_on "watchman"

  def install
    bin.install "rs-git-fsmonitor"
  end

  def post_install
    ohai "Run `git config --global core.fsmonitor rs-git-fsmonitor` to install!"
  end

  test do
    system "git init . && git config core.fsmonitor rs-git-fsmonitor && git status"
  end
end

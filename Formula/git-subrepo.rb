class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/0.4.0.tar.gz"
  sha256 "e60243efeebd9ae195559400220366e7e04718123481b9da38344e75bab71d21"
  head "https://github.com/ingydotnet/git-subrepo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42b325b885d57a35c7a6ad8c72cbc26ff39956013e8d3d0194fdab44083fcf65" => :mojave
    sha256 "ee31c24df2bf36697f81c0b2b4f1779f4bb4987187050ba28bb7ff6069c12383" => :high_sierra
    sha256 "f7d319ded76484efef8f34b45853e97c5d663cc2c4e76e91ed0f6a7fae1a8edb" => :sierra
    sha256 "f7d319ded76484efef8f34b45853e97c5d663cc2c4e76e91ed0f6a7fae1a8edb" => :el_capitan
    sha256 "f7d319ded76484efef8f34b45853e97c5d663cc2c4e76e91ed0f6a7fae1a8edb" => :yosemite
  end

  def install
    libexec.mkpath
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"

    # Remove test for $GIT_SUBREPO_ROOT in completion script
    # https://github.com/ingydotnet/git-subrepo/issues/183
    inreplace "share/zsh-completion/_git-subrepo",
              /^if [[ -z $GIT_SUBREPO_ROOT ]].*?^fi$/m, ""

    mv "share/completion.bash", "share/git-subrepo"
    bash_completion.install "share/git-subrepo"
    zsh_completion.install "share/zsh-completion/_git-subrepo"
  end

  test do
    mkdir "mod" do
      system "git", "init"
      touch "HELLO"
      system "git", "add", "HELLO"
      system "git", "commit", "-m", "testing"
    end

    mkdir "container" do
      system "git", "init"
      touch ".gitignore"
      system "git", "add", ".gitignore"
      system "git", "commit", "-m", "testing"

      assert_match(/cloned into/,
                   shell_output("git subrepo clone ../mod mod"))
    end
  end
end

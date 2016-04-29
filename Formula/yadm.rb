class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://github.com/TheLocehiliosan/yadm"
  url "https://github.com/TheLocehiliosan/yadm/archive/1.04.tar.gz"
  sha256 "a73aa51245866ce67aeb4322a62995ebbb13f29dc35508f486819dceb534968a"

  def install
    bin.install "yadm"
    man1.install "yadm.1"
  end

  test do
    # init a new repo
    system bin/"yadm", "init"
    assert File.exist?(testpath/".yadm/repo.git/config"), "Failed to init repository."

    # confirm worktree set to $HOME
    assert_match testpath.to_s, shell_output("#{bin}/yadm gitconfig core.worktree")

    # disable auto-alt
    system bin/"yadm", "config", "yadm.auto-alt", "false"
    assert_match "false", shell_output("#{bin}/yadm config yadm.auto-alt")

    # create a test file, and add it to the repo
    (testpath/"testfile").write "test"
    system bin/"yadm", "add", "#{testpath}/testfile"

    # configure git identity
    system bin/"yadm", "gitconfig", "user.email", "test@test.org"
    system bin/"yadm", "gitconfig", "user.name", "Test User"

    # commit the test file to the repo
    system bin/"yadm", "commit", "-m", "test commit"

    # verify the log
    assert_match "test commit", shell_output("#{bin}/yadm log --pretty=oneline 2>&1")
  end
end

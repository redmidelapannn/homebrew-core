class GitWebui < Formula
  desc "Local web based user interface for git repositories"
  homepage "https://github.com/alberthier/git-webui"
  url "https://github.com/alberthier/git-webui/archive/v1.2.0.tar.gz"
  sha256 "21faa8a018d7325bd3acb7e7da138a2a61b504698f96fd067fa0ee765f3f15dd"
  head "https://github.com/alberthier/git-webui.git"

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    prefix.install Dir["release/*"]
    bin.install_symlink prefix/"libexec/git-core/git-webui"

    # make sure the original script resolves the path to the assets correctly
    inreplace libexec/"git-core/git-webui", ".abspath(sys.argv[0])", ".realpath(sys.argv[0])"
  end

  test do
    system "git-webui", "--help"
  end
end

class GitWebui < Formula
  desc "Local web based user interface for git repositories"
  homepage "https://github.com/alberthier/git-webui"
  url "https://github.com/alberthier/git-webui/archive/v1.2.0.tar.gz"
  sha256 "21faa8a018d7325bd3acb7e7da138a2a61b504698f96fd067fa0ee765f3f15dd"
  head "https://github.com/alberthier/git-webui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c083445b8aeb6deef1206fd625b9ea256e89ffaee6a75b04fc26b7b77e58231e" => :el_capitan
    sha256 "d99b8f701d9b5d872f8c2c2f9b7f693e27e280ee95a5271e1fc20954210c5a70" => :yosemite
    sha256 "c8037c6600d492b93ff641cb16522c3d1bb432eecff65c99c32526ce2a482300" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    prefix.install Dir["release/*"]
    bin.install_symlink prefix/"libexec/git-core/git-webui"

    # make sure the original script resolves the path to the assets correctly
    # a patch was submitted to change this in the upstream repo:
    # https://github.com/alberthier/git-webui/pull/24
    inreplace libexec/"git-core/git-webui", ".abspath(sys.argv[0])", ".realpath(sys.argv[0])"
  end

  test do
    output = `#{bin}/git-webui --repo-root #{testpath} 2>&1`
    assert_equal "No git repository found", output.strip
  end
end

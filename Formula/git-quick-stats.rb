class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git."
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/1.0.1.tar.gz"
  sha256 "397fabda3e894bf058767e32114ce8496ecf23f088e6de6203cae4486e1f755b"

  bottle do
    cellar :any_skip_relocation
    sha256 "23e4d977de1fa408dbbebf1420cfb132fded75ce9fd7acdf83b18e9190ff7d89" => :sierra
    sha256 "23e4d977de1fa408dbbebf1420cfb132fded75ce9fd7acdf83b18e9190ff7d89" => :el_capitan
    sha256 "23e4d977de1fa408dbbebf1420cfb132fded75ce9fd7acdf83b18e9190ff7d89" => :yosemite
  end

  def install
    bin.install "git-quick-stats"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
    shell_output("#{bin}/git-quick-stats branchesByDate")
    assert_match /^Invalid argument/, shell_output("#{bin}/git-quick-stats command")
  end
end

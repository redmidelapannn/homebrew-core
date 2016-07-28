class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.3.tar.gz"
  sha256 "f4d150c840189053fd327a5141361369b6ed80d57a6bbdd84e9d035777c87b0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fff34b2f9a08fb0f8d52f9e9226a9e1023f0bf46ebbefaa88b7ad99bc1c58a6" => :el_capitan
    sha256 "ebb1fc424ff57ad80aa28acd5fb1589efd877727bcdeef6d0958c27c1d5c4884" => :yosemite
    sha256 "0e438faa8895afe3dc3c0e56230de4476c9ea7f842a7f93f2628679f03f586b5" => :mavericks
  end

  def install
    system "make", "build"
    bin.install "bin/git-octopus", "bin/git-conflict", "bin/git-apply-conflict-resolution"
    man1.install "doc/git-octopus.1", "doc/git-conflict.1"
  end

  test do
    (testpath/".gitconfig").write <<-EOS.undent
      [user]
        name = Real Person
        email = notacat@hotmail.cat
      EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "."
    system "git", "commit", "--message", "brewing"

    assert_equal "", shell_output("#{bin}/git-octopus 2>&1", 0).strip
  end
end

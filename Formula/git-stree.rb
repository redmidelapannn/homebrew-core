class GitStree < Formula
  desc "Git subtree helper command"
  homepage "https://github.com/tdd/git-stree"
  url "https://github.com/tdd/git-stree/archive/0.4.5.tar.gz"
  sha256 "5504ac90871c73c92c21f5cd84b0bf956c521b237749e2b2dd699dbe0c096af8"
  head "https://github.com/tdd/git-stree.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "fafd88740d3cd4ca7f14aed98b7cb94a99fd575f3f66d22f28267a7926db91d5" => :el_capitan
    sha256 "1622cfc3ef8e6f97404d95f80bd5f2f98c58a36cdfd6fa49301e17d44a493319" => :yosemite
    sha256 "88ca9dc7cb87521f073885a3c504c24a76435151c27ad865b47eca4ff97d27d0" => :mavericks
  end

  def install
    bin.install "git-stree"
    bash_completion.install "git-stree-completion.bash" => "git-stree"
  end

  def caveats; <<-EOS.undent
    THIS PROJECT IS DEPRECATED

      Maintenance of git stree has stopped in favor of another third-party project: `git-subrepo`.
      Please check the homepage for more information.
    EOS
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

      system "git", "stree", "add", "mod", "-P", "mod", "../mod"
    end
  end
end

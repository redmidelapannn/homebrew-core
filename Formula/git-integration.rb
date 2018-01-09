class GitIntegration < Formula
  desc "Manage git integration branches"
  homepage "https://johnkeeping.github.io/git-integration/"
  url "https://github.com/johnkeeping/git-integration/archive/v0.4.tar.gz"
  sha256 "b0259e90dca29c71f6afec4bfdea41fe9c08825e740ce18409cfdbd34289cc02"
  head "https://github.com/johnkeeping/git-integration.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f559db0ee3e8aeaa4b3773eeecb1d3043a9648dfe31844f626b0addf5fbb2692" => :high_sierra
    sha256 "f559db0ee3e8aeaa4b3773eeecb1d3043a9648dfe31844f626b0addf5fbb2692" => :sierra
    sha256 "f559db0ee3e8aeaa4b3773eeecb1d3043a9648dfe31844f626b0addf5fbb2692" => :el_capitan
  end

  depends_on "asciidoc" => [:build, :optional]

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    (buildpath/"config.mak").write "prefix = #{prefix}"
    system "make", "install"
    system "make", "install-doc" if build.with? "asciidoc"
    system "make", "install-completion"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "An initial commit"
    system "git", "checkout", "-b", "branch-a", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-a"
    system "git", "checkout", "-b", "branch-b", "master"
    system "git", "commit", "--allow-empty", "-m", "A commit on branch-b"
    system "git", "checkout", "master"
    system "git", "integration", "--create", "integration"
    system "git", "integration", "--add", "branch-a"
    system "git", "integration", "--add", "branch-b"
    system "git", "integration", "--rebuild"
  end
end

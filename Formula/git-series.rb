class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"

  bottle do
    rebuild 2
    sha256 "3aa32809f4c93d393da0a4a07e4fc54658e302880a86ec5829e7ca52870cd996" => :high_sierra
    sha256 "3993efc88f5318f1ca31417dda0bd3ba1fed023c2b5eb57a83e1337cc169a166" => :sierra
    sha256 "21628a4da9bbd0199f9af4fab8287f960032b9d1004b4843f0096058bc5159bf" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "libssh2"

  def install
    system "cargo", "install", "--root", prefix
    man1.install "git-series.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS

    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").append_lines "bar"
    system "git", "commit", "-m", "Second commit", "test"
    system bin/"git-series", "start", "feature"
    system "git", "checkout", "HEAD~1"
    system bin/"git-series", "base", "HEAD"
    system bin/"git-series", "commit", "-a", "-m", "new feature v1"
  end
end

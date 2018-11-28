class GitArchiveAll < Formula
  desc "Archive a project and its submodules"
  homepage "https://github.com/Kentzo/git-archive-all"
  url "https://github.com/Kentzo/git-archive-all/archive/1.19.3.tar.gz"
  sha256 "aa7bdb03b55cf818fa2b28628cd06b3b5dcd60ba89875d5d2f69c547472abffb"
  head "https://github.com/Kentzo/git-archive-all.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0ae4b3a3e2718cc0c967f5b82e81bd77c145ef07f9ed009fdc58078cea487af" => :mojave
    sha256 "bcb55f81c204038df9bf4ee74418b01ef018f27d029b2917dbdf71acb359ff9a" => :high_sierra
    sha256 "bcb55f81c204038df9bf4ee74418b01ef018f27d029b2917dbdf71acb359ff9a" => :sierra
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    touch "homebrew"
    system "git", "add", "homebrew"
    system "git", "commit", "--message", "brewing"

    assert_equal "#{testpath.realpath}/homebrew => archive/homebrew",
                 shell_output("#{bin}/git-archive-all --dry-run ./archive").chomp
  end
end

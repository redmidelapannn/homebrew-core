require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-6.20180316/git-annex-6.20180316.tar.gz"
  sha256 "8b15ebd8dd2b8bef52d040c25c75000f59bc23ccc5c8b261aa244eae63f4ba71"
  head "git://git-annex.branchable.com/"

  bottle do
    rebuild 1
    sha256 "af127e21843c8347c32ee7b5ec044f7ceef7bf41425d6b522fa3ac5558d03aa9" => :high_sierra
    sha256 "153203add46eb28d27d17f7e686b38d86703b0c8a5245931e92f52077c3e27a7" => :sierra
    sha256 "97cdfd2ba1a0b32d213b6e1ca10f47cf90ea57f84372969877d27ac683d98b85" => :el_capitan
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libmagic"
  depends_on "quvi"
  depends_on "xdot" => :recommended

  def install
    # Reported 28 Feb 2018 to aws upstream https://github.com/aristidb/aws/issues/244
    install_cabal_package "--constraint", "http-conduit<2.3",
                          :using => ["alex", "happy", "c2hs"],
                          :flags => ["s3", "webapp"] do
      # this can be made the default behavior again once git-union-merge builds properly when bottling
      if build.with? "git-union-merge"
        system "make", "git-union-merge", "PREFIX=#{prefix}"
        bin.install "git-union-merge"
        system "make", "git-union-merge.1", "PREFIX=#{prefix}"
      end
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    # We don't want this here or it gets "caught" by git-annex.
    rm_r "Library/Python/2.7/lib/python/site-packages/homebrew.pth"

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    assert !File.symlink?("Hello.txt")
    assert_match "add Hello.txt ok", shell_output("git annex add .")
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

    # The steps below are necessary to ensure the directory cleanly deletes.
    # git-annex guards files in a way that isn't entirely friendly of automatically
    # wiping temporary directories in the way `brew test` does at end of execution.
    system "git", "rm", "Hello.txt", "-f"
    system "git", "commit", "-a", "-m", "Farewell!"
    system "git", "annex", "unused"
    assert_match "dropunused 1 ok", shell_output("git annex dropunused 1 --force")
    system "git", "annex", "uninit"
  end
end

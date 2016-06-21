class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo."
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.2.0.tar.gz"
  sha256 "db4afbc3a453df2527603bf8bfffd9946f00d5595f2dca4f5088cb6bb47cacdf"
  revision 1

  head "https://github.com/sobolevn/git-secret.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c378d1e15aa96969876bdb40c46d4156c4ded79dafa762bba94fc3d05246a62f" => :el_capitan
    sha256 "5286b9f107eaa78cf7e18c21a38c03dffc01af284a83b78b8781303073f73add" => :yosemite
    sha256 "e11f5688d1a92e9c9af5c25aa8fbb3efd9fbd3c30cf7326ec6c5b92c204b4b4f" => :mavericks
  end

  depends_on :gpg => :recommended

  def install
    # Prefer GPG2 by default.
    inreplace "src/_utils/_git_secret_tools.sh", ':="gpg"', ':="gpg2"'
    system "make", "build"
    system "bash", "utils/install.sh", prefix
  end

  def caveats; <<-EOS.undent
    Homebrew defaults `git-secret` to using `gpg2`. If you
    wish to use alternative GPG executables you should add:
      export SECRETS_GPG_COMMAND="gpg"
    to your shell profile.
  EOS
  end

  test do
    # Note that test do is always in temporary path, with HOME captured,
    # so this doesn't interfere with a user's pre-existing keychain.
    (testpath/"batchgpg").write <<-EOS.undent
    Key-Type: RSA
    Key-Length: 2048
    Subkey-Type: RSA
    Subkey-Length: 2048
    Name-Real: Testing
    Name-Email: testing@foo.bar
    Expire-Date: 1d
    Passphrase: brew
    %commit
    EOS
    system "gpg2", "--batch", "--gen-key", "batchgpg"

    system "git", "init"
    system "git", "config", "user.email", "testing@foo.bar"
    system "git", "secret", "init"
    assert_match "testing@foo.bar added", shell_output("git secret tell -m")
    (testpath/"shh.txt").write "Top Secret"
    (testpath/".gitignore").write "shh.txt"
    system "git", "secret", "add", "shh.txt"
    system "git", "secret", "hide"
    assert File.exist?("shh.txt.secret")
  end
end

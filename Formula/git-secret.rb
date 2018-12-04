class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://sobolevn.github.io/git-secret/"
  head "https://github.com/sobolevn/git-secret.git"
  revision 1

  stable do
    url "https://github.com/sobolevn/git-secret/archive/v0.2.4.tar.gz"
    sha256 "dd9962935f242a94bb00af6a31171de0fdba357171a6c626efc2635751d52bc4"

    # Remove for > 0.2.4
    # Upstream PR from 12 Jun 2018 "Revert 'migrate from bats to bats-core'"
    patch do
      url "https://github.com/sobolevn/git-secret/pull/203.patch?full_index=1"
      sha256 "ee4e263b9725aee59f8b52196d4749a09791dbb4c745a9e81da523d27fcf3f09"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9325b3c0cee67ae2baf831116dff4c991b8e8842346d3b78d7a02b7344f303b4" => :mojave
    sha256 "2353e069e71a69b9a7780005a2833747ed3f55e0ac875faf0d51a3b380696413" => :high_sierra
    sha256 "2353e069e71a69b9a7780005a2833747ed3f55e0ac875faf0d51a3b380696413" => :sierra
  end

  depends_on "gawk"
  depends_on "gnupg" => :recommended

  def install
    system "make", "build"
    system "bash", "utils/install.sh", prefix
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system "git", "init"
      system "git", "config", "user.email", "testing@foo.bar"
      system "git", "secret", "init"
      assert_match "testing@foo.bar added", shell_output("git secret tell -m")
      (testpath/"shh.txt").write "Top Secret"
      (testpath/".gitignore").append_lines "shh.txt"
      system "git", "secret", "add", "shh.txt"
      system "git", "secret", "hide"
      assert_predicate testpath/"shh.txt.secret", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

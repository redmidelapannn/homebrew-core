# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.1.0",
      :revision => "36aa8c8dd1936e10ebd7a4c1d412ae0e6f7900bd"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a63bb70ca736cce32b714846e9ccf3a6e6574143cdd1a5aff1f40ff6fe4837f9" => :mojave
    sha256 "c38d158b555c3b4765164d2fb7f7fdcf2ebc9c293f7d309dd51238af2fa8f3d4" => :high_sierra
    sha256 "531ee5245e5d5d65da61dcb30c5d59c5c7c631cc98ad0e70ef1a821a1d16b08a" => :sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      system "make", "dev"
      bin.install "bin/vault"
      prefix.install_metafiles
    end
  end

  test do
    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end

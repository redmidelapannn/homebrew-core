# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.7.0",
      :revision => "614deacfca3f3b7162bbf30a36d6fc7362cd47f0"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "18a938227e620beef1468e89dde4203599d655e67a82a1148de6805795051cec" => :sierra
    sha256 "4f2c540456078227a5d4d43d8fc181afb3924f06c3b07e1861a1e1d27c0722ab" => :el_capitan
    sha256 "d3d71d819d9aacbc8a50c282984dc6f612d90406d0b4914dec85181e49c80602" => :yosemite
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/hashicorp/vault"
    dir.install buildpath.children - [buildpath/".brew_home"]

    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd dir do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "bootstrap"
      system "make", "bin"

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

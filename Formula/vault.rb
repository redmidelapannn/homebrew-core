# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v0.11.4",
      :revision => "612120e76de651ef669c9af5e77b27a749b0dba3"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6e09cd3b42c3d6015d7481e859cd534506deac8cf55bbb3d323d637a1f44da4a" => :mojave
    sha256 "b973daceed160ff289b9b8ab5762bb387b52e9e696ffc836849e092dbb340df5" => :high_sierra
    sha256 "921e9128dd2b3284fcf7f7f406813fa63daac48b76a4a714ea3d0941c10cfeb5" => :sierra
  end

  option "with-dynamic", "Build dynamic binary with CGO_ENABLED=1"

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      target = build.with?("dynamic") ? "dev-dynamic" : "dev"
      system "make", target
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

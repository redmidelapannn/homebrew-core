class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v1.1.0.tar.gz"
  sha256 "fc72d88f3eac0ce2105fe99c1bdbfec211609b1bce1c032cd268617c4bd484a2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8008f329a336b47ab9154756a555e77e02faab50c96330cb7776c5d07bfe8f51" => :mojave
    sha256 "36db181a6ee546c229c167aed97d344b92c45bb5f916cb4188e64d1d53d5e754" => :high_sierra
    sha256 "c75af6718681e01293684211147f43b92a30c233b8930f9392317b5620679a85" => :sierra
  end

  depends_on "go" => :build
  depends_on "vault"

  def install
    ENV["GOPATH"] = buildpath
    ENV["VERSION"] = version

    (buildpath/"src/github.com/starkandwayne/safe").install buildpath.children

    cd "src/github.com/starkandwayne/safe" do
      system "make", "build"
      bin.install "safe"
      prefix.install_metafiles
    end
  end

  test do
    require "yaml"

    pid = fork { exec "#{bin}/safe", "local", "--memory" }
    sleep 1
    handshake_yaml = Utils.popen_read("#{bin}/safe", "get", "secret/handshake")
    Process.kill("TERM", pid)

    parsed = YAML.safe_load(handshake_yaml)
    assert_equal "knock", parsed["knock"]
  end
end

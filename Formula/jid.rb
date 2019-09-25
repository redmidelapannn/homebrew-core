class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/v0.7.6.tar.gz"
  sha256 "0912050b3be3760804afaf7ecd6b42bfe79e7160066587fbc0afa5324b03fb48"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "018b6061e0162a25169dcfc5adf35ac2cb2633a0b18b3ac5c0f239bfc142899e" => :mojave
    sha256 "36e7fdedb64e5bd6436f8c838506f195ae2c25105d55d51441fcd1fd2b3fc9de" => :high_sierra
    sha256 "96f5c5cdc5ac348bda9a3428d706e829f0aefc52cb378caa5f0c651a685dbc1e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/simeji/jid"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"jid", "cmd/jid/jid.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end

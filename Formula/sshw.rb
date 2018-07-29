class Sshw < Formula
  desc "🐝  ssh client wrapper for automatic login"
  homepage "https://github.com/yinheli/sshw"
  url "https://github.com/yinheli/sshw/archive/v1.0.4.tar.gz"
  sha256 "53b1a4e010fc36713961aa5ce7093efc9dba07b3bf38c01f86d016b669cbc285"

  bottle do
    cellar :any_skip_relocation
    sha256 "35a20ebeea35d5d7249fc7162d44ae591ab4720d1c3547fc4e59d2e6efedbcef" => :high_sierra
    sha256 "0d2f1ab6680f690e78f2ef1c16836a8de112b0d0b0458fcee9f1b5da127fe04b" => :sierra
    sha256 "c7a81fd9207a6f00ab77fba8686f0bf75a8ec6679ad172cb72086a81b6750a9f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/yinheli/sshw").install buildpath.children

    cd "src/github.com/yinheli/sshw" do
      system "make", "sshw"
      bin.install "release/sshw"
    end
  end

  test do
    system "#{bin}/sshw", "-version"
  end
end

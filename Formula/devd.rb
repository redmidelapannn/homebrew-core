class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.8.tar.gz"
  sha256 "a73bd347f0d0f452be183e365492fb8bb86954b3cd837c9dfe256926bf7feb5b"
  head "https://github.com/cortesi/devd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "624425044a4ab2141177e4ab1ad93057596b178a63b855b182b73bf65492d73f" => :mojave
    sha256 "507bdc1ef0ce223215f5d5048d74b78530dc3f8245546b2d8a4e6e42f23bd556" => :high_sierra
    sha256 "9fb42c234e53b87218adbba912c87a03885b10430d38cb066d86b60c0859071a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/cortesi/devd").install buildpath.children
    cd "src/github.com/cortesi/devd" do
      system "go", "build", "-o", bin/"devd", ".../cmd/devd"
      prefix.install_metafiles
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/devd -s #{testpath}")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Listening on https://devd.io", io.read
  end
end

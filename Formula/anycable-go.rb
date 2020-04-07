class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.5.tar.gz"
  sha256 "3112a04db1984151b9e4111a0131b711f6a0a79ccf789fbaf6da1ea9e28608dc"
  head "https://github.com/anycable/anycable-go.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "971915a542e3abc329551de76061f0e7330ffbe9b80a4cc158fe94f8ba34b6cd" => :catalina
    sha256 "3e931d31cdf990a459545d7f1a656c41ecd442f755fe3ca0a0e718a0f54abd0e" => :mojave
    sha256 "5e991de49e3164b8c39838d44a46ee287c2a843e64099a8c10d7d2734173fcfa" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}",
                          "-trimpath", "-o", "#{bin}/anycable-go",
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end

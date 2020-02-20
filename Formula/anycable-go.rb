class AnycableGo < Formula
  desc "Anycable Go WebSocket Server"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v0.6.4.tar.gz"
  sha256 "dbcfccdedc7d28d2d70e12a6c2aff77be28a65dcaa27386d3b65465849fff162"
  head "https://github.com/anycable/anycable-go.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "2e2628e695605cf988a57e57bc704e3ad74ffd842d93de52088ada2b6a65ac6b" => :catalina
    sha256 "0beedf056b5257d1e08e3b76c7e42a53b905eaf7373e46aa638b006d3bd493cd" => :mojave
    sha256 "9485fc0a96ed29722707b18b2e8d449df9ee6a0e0d30d994676e0cf5d90885fd" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", "#{bin}/anycable-go", "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
  end

  test do
    pid = fork do
      exec "#{bin}/anycable-go"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:8080/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end

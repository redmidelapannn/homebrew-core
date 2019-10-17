class Chartmuseum < Formula
  desc "Host your own Helm Chart Repository"
  homepage "https://chartmuseum.com"
  url "https://github.com/helm/chartmuseum/archive/v0.9.0.tar.gz"
  sha256 "e5fed41b098141a56037340ad3b0857c7defae6d143af56b6003a270cc75631f"

  bottle do
    cellar :any_skip_relocation
    sha256 "70e9580c7ab001cfa1eab8369888b4d85e276d2244fda1b592ef7c23f98a9a2a" => :catalina
    sha256 "95e9b5179d3de896220f44666e8f80cb44cf4c0e6a946b3bad2cbc05a3ece6ec" => :mojave
    sha256 "1b74daf5e4b7579390f017486d19ccadfbb8ade5fed56371350d8b978ce813c5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"
    ENV["GO111MODULE"] = "on"
    ENV["GOPROXY"] = "https://gocenter.io"

    system "go",
        "build",
        "-v",
        "-ldflags",
        "-X main.Version=#{version} -X main.Revision=9382222",
        "-o",
        "bin/darwin/amd64/chartmuseum",
        "cmd/chartmuseum/main.go"

    bin.install "bin/darwin/amd64/chartmuseum"
  end

  test do
    begin
      io = IO.popen("#{bin}/chartmuseum --port 33333 --storage=local --storage-local-rootdir=#{testpath} 2>#{testpath}/output.log")
      sleep 2
    ensure
      Process.kill("SIGTERM", io.pid)
      Process.wait(io.pid)
    end

    assert_predicate testpath/"output.log", :exist?, "output.log file should exist"
    assert_match "Starting ChartMuseum	{\"port\": 33333}", File.read(testpath/"output.log")

    puts "Test success!!!"
    exec "kill $(lsof -t -i :33333)"
  end
end

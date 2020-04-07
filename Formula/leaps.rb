class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag      => "v0.9.0",
      :revision => "89d8ab9e9130238e56a0df283edbcd1115ec9225"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0e944c64b96cd9c9f5a04a4a6a91a533d30186e72674285b463cac58de9207d2" => :catalina
    sha256 "84688a7d0c8ca3a84696820167bdc5c4f3f69b8799da417fb49ae02feaea0557" => :mojave
    sha256 "0eee88056ffbeef8e06fe1f3081c5c3182368dd40bbde3d1eaec1c4ecb0c9d95" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jeffail/leaps").install buildpath.children
    cd "src/github.com/jeffail/leaps" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"leaps", "./cmd/leaps"
      prefix.install_metafiles
    end
  end

  test do
    port = ":#{free_port}"

    # Start the server in a fork
    leaps_pid = fork do
      exec "#{bin}/leaps", "-address", port
    end

    # Give the server some time to start serving
    sleep(1)

    # Check that the server is responding correctly
    assert_match "You are alone", shell_output("curl -o- http://localhost#{port}")
  ensure
    # Stop the server gracefully
    Process.kill("HUP", leaps_pid)
  end
end

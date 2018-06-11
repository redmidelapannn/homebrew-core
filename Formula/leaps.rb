class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag => "v0.9.0",
      :revision => "89d8ab9e9130238e56a0df283edbcd1115ec9225"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d1a557eb34624c82da0c13feeb6738f6acc04399d1149b36bbe40cc4d40cd5ae" => :high_sierra
    sha256 "4df05170bda39a9b21db80484b5394a7b2411e057cd47a033cbb534174bc90f1" => :sierra
    sha256 "0b3ce4335d789e9411a403f40d6ba608020d96164038188740d0cf8b9350ee83" => :el_capitan
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
    begin
      port = ":8080"

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
end

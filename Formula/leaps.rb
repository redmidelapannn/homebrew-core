class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag => "v0.9.0",
      :revision => "89d8ab9e9130238e56a0df283edbcd1115ec9225"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e7d7198a5f776e188db21220712959269781335ab7682f5544ffd90cdb2dbf0b" => :high_sierra
    sha256 "e997e6bf5a1ec4676e3af0d58a26f16a6341b9bccfc35d4d8b6400b23c4ca6e2" => :sierra
    sha256 "9481b65965b088a617f5f72214042ca496fe3c22883cd878e6941839f47de4e8" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jeffail/leaps").install buildpath.children
    cd buildpath/"src/github.com/jeffail/leaps" do
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

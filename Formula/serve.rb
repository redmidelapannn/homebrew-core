class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/v0.4.0.tar.gz"
  sha256 "5329738cc72bcee9c7d327981e256369c623257f7f9bd282592deafccacee6f1"
  head "https://github.com/syntaqx/serve.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84ed08976ef81645483c8500c215b7070b949b6b3e5c37fe636d9d014ff7841e" => :catalina
    sha256 "101950566356ab9a80e54bab22dab691cc8a313a4ea49b2903ae4fda62312c0b" => :mojave
    sha256 "1a374819c44d77a599229fa852e2427a8a0667775b411123fcaafee89968a1d6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/syntaqx/serve"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"serve", "./cmd/serve"
      prefix.install_metafiles
    end
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/serve -port #{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end

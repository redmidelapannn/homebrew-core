class Serve < Formula
    desc "Static http server anywhere you need one"
  bottle do
    cellar :any_skip_relocation
    sha256 "fd0b31d89bb18feb97778a133ffd21e827bd363004dd7dd0ffc980579139dc62" => :mojave
    sha256 "e9c4b189fb5c0f194cbc65732531c7bb70e9eca2f5f9af2f29fce7e510341732" => :high_sierra
    sha256 "dc8339985922354f26a2888982db69a21cbaf5f23285ae216d253de89c875c45" => :sierra
  end

    homepage "https://github.com/syntaqx/serve"
    url "https://github.com/syntaqx/serve/archive/v0.2.0.tar.gz"
    sha256 "ff4d33c2d7fc95546023f3710619098e4e3220255a2b09ec67ed6cbf57ea4d06"

    depends_on "go" => :build

    def install
      ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
      (buildpath/"src/github.com/syntaqx/serve").install buildpath.children
      cd "src/github.com/syntaqx/serve" do
        system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"serve", "./cmd/serve"
        prefix.install_metafiles
      end
    end

    test do
      begin
        pid = fork do
          exec "#{bin}/serve"
        end
        sleep 1
        output = shell_output("curl -sI http://localhost:8080")
        assert_match /200 OK/m, output
      ensure
        Process.kill("HUP", pid)
      end
    end
  end

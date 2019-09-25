class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/v0.4.0.tar.gz"
  sha256 "5329738cc72bcee9c7d327981e256369c623257f7f9bd282592deafccacee6f1"
  head "https://github.com/syntaqx/serve.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "03a2a6a41d1af37a41dcc1cd34d5cf0eb868c4905153e07219338595c3be3947" => :mojave
    sha256 "effd5d9be5deaf28bd76dfaf7e8adea40de96bff12a8878ce00c704a8b9073fd" => :high_sierra
    sha256 "f51a03b4dccf226a9a18142958ccfe35decaf7b78e77eaa77b9a43330493ae70" => :sierra
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
    begin
      pid = fork do
        exec "#{bin}/serve"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match(/200 OK/m, output)
    ensure
      Process.kill("HUP", pid)
    end
  end
end

class Tunnel < Formula
  desc "Expose local servers to internet securely"
  homepage "https://labstack.com/docs/diy/tunnel"
  url "https://github.com/labstack/tunnel/archive/0.2.7.tar.gz"
  sha256 "6b4a6564732e2e86e49450629a72dc7ef647088ef66f568cb507d1e0c9b5588f"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    tunnelpath = buildpath/"src/github.com/labstack/tunnel"
    tunnelpath.install buildpath.children

    cd tunnelpath do
      system "go", "build", "-o", bin/"tunnel", "cmd/tunnel/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        $stdout.reopen("#{testpath}/out", "w")
        exec "#{bin}/tunnel", "8080"
      end
      sleep 5
      assert_match /labstack.me/m, File.read("#{testpath}/out")
    ensure
      Process.kill("HUP", pid)
    end
  end
end

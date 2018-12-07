class GostProxy < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://github.com/ginuerzh/gost"
  url "https://github.com/ginuerzh/gost/archive/v2.6.1.tar.gz"
  sha256 "d8231f5869e54066e0f1ba333d0209727bfe14998d296ebdf7b423d0c33209c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2a92df33545dc41c8a3b489978d1e8cb3b9a964e167468005ace18f2700aad7" => :mojave
    sha256 "d87ca00ed86a8e2b121c773211f18d0f69b9f1f8a18959598f3912ebe3a5e89e" => :high_sierra
    sha256 "4da57f6b706ee03bfddad91b3898b96d9753216649a3c317ed411041f24497b7" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/ginuerzh/gost").install buildpath.children
    cd "src/github.com/ginuerzh/gost" do
      system "go", "build", "-o", bin/"gost-proxy", "./cmd/gost"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"index.html").write("Gost Proxy Test")

    pid_gost = fork do
      exec "#{bin}/gost-proxy -D -L=http://localhost:8080"
    end

    pid_http = fork do
      exec "python -m SimpleHTTPServer 8000"
    end

    sleep 2

    begin
      output = shell_output("curl -x http://localhost:8080 http://localhost:8000/index.html")
      assert_match "Gost Proxy Test", output, "Gost proxy server did not start!"
    ensure
      Process.kill("SIGINT", pid_gost)
      Process.kill("SIGKILL", pid_http)
      Process.wait(pid_gost)
      Process.wait(pid_http)
    end
  end
end

class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.3.1.tar.gz"
  sha256 "323700908ca7fe7b69cb2cc492b4746c4cd3449e49fbab15a4b3a5eccf8757f4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f808075ebee8b3dc18d587a7fb59227db3d2f7537ddf2b596669c83491327f45" => :catalina
    sha256 "c4c35d93d30d2cbb79e6df05831dafabc4649b211bea0ea18999edf44d9045bc" => :mojave
    sha256 "95f815b058d20666e237616a8b88a107e916af5c26e21448cdb7599be4274e5c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/joewalnes/websocketd"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"websocketd"
      man1.install "release/websocketd.man" => "websocketd.1"
      prefix.install_metafiles
    end
  end

  test do
    port = free_port
    pid = Process.fork { exec "#{bin}/websocketd", "--port=#{port}", "echo", "ok" }
    sleep 2

    begin
      assert_equal("404 page not found\n", shell_output("curl -s http://localhost:#{port}"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

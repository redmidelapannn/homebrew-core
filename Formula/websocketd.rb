class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.3.1.tar.gz"
  sha256 "323700908ca7fe7b69cb2cc492b4746c4cd3449e49fbab15a4b3a5eccf8757f4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ee02f05749cd8828d86d47374780bb6452cb1a9df5a2221eccd1de72d22eb35d" => :mojave
    sha256 "7b013805291f0f2d393d24a878ec6c8904463e421316fac9bc61ce7b9d52737e" => :high_sierra
    sha256 "ecd2d6f117ccccd4a1f063e65d727846fb49f141b57618364be6f507f1ccb4ca" => :sierra
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
    pid = Process.fork { exec "#{bin}/websocketd", "--port=8080", "echo", "ok" }
    sleep 2

    begin
      assert_equal("404 page not found\n", shell_output("curl -s http://localhost:8080"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

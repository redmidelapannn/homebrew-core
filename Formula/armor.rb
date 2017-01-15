class Armor < Formula
  desc "Uncomplicated HTTP server, supports HTTP/2 and auto TLS"
  homepage "https://github.com/labstack/armor"
  url "https://github.com/labstack/armor/archive/v0.2.5.tar.gz"
  sha256 "392ffc6004f660f67b9d1b0fe570e8de4c812e5420810ab23c64d3f0cd69b159"
  head "https://github.com/labstack/armor.git"

  bottle do
    sha256 "764e7ac3c38cb3cbc0de66286d282a4f5e0d7b3288cd059dcdc83080b8965109" => :sierra
    sha256 "13702852578e2a63593e94a026cd37fe8cda1a6bdae9d324bf4ae7d6c03f0294" => :el_capitan
    sha256 "2e59de55cfdde5b841279c9fde7832b903a10b7f538410d8aafd7487d96ff98e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    armorpath = buildpath/"src/github.com/labstack/armor"
    armorpath.install buildpath.children

    cd armorpath do
      system "go", "build", "-o", bin/"armor", "cmd/armor/main.go"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/armor"
      end
      sleep 1
      output = shell_output("curl -sI http://localhost:8080")
      assert_match /200 OK/m, output
    ensure
      Process.kill("HUP", pid)
    end
  end
end

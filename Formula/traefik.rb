require "language/go"

class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v1.5.1/traefik-v1.5.1.src.tar.gz"
  version "1.5.1"
  sha256 "8d052ba499ebf162bb7f110cbf45f630c5490dc6a682c35c39ee79d3c79463d9"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0943879dda09c1f22f3b4c13f24b008d11eb466541da4ed846c1417383802a4d" => :high_sierra
    sha256 "9ac4678a45b14ea7948a273abbbb3064679b72b1751f783a1c839bd20431ff43" => :sierra
    sha256 "1aedced434bc2ac9efd2c573052d75dede6a046cf19ace3502b2496c670ca9d4" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  go_resource "github.com/containous/go-bindata" do
    url "https://github.com/containous/go-bindata.git",
        :revision => "e237f24c9fab3ae0ed95bf04e3699e92c2a41283"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/containous/traefik").install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/containous/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd "src/github.com/containous/traefik" do
      cd "webui" do
        system "yarn", "install"
        system "yarn", "run", "build"
      end
      system "go", "generate"
      system "go", "build", "-o", bin/"traefik", "./cmd/traefik"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"

    web_server = TCPServer.new(0)
    http_server = TCPServer.new(0)
    web_port = web_server.addr[1]
    http_port = http_server.addr[1]
    web_server.close
    http_server.close

    (testpath/"traefik.toml").write <<~EOS
      [web]
      address = ":#{web_port}"

      [entryPoints.http]
      address = ":#{http_port}"
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd = "curl -sIm3 -XGET http://localhost:#{web_port}/dashboard/"
      assert_match /200 OK/m, shell_output(cmd)
    ensure
      Process.kill("HUP", pid)
    end
  end
end

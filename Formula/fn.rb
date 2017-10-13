class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.github.io"
  url "https://github.com/fnproject/cli/archive/0.4.11.tar.gz"
  sha256 "adc39a305a22fccc356d2661b4878c7fe7c39153bc40b8693af580e01612873f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb1fe7d330b6f80f352de96bad7f11b78aad57242bae3a50529f90eddf543070" => :high_sierra
    sha256 "90274762548cc016415df89cb0cd870fe4f604a13be48297e9c6f14e4926b10b" => :sierra
    sha256 "9d3c9c5ff1a5c1dd5a7497e6d5051952a0e3f3db17887799c5d8ed9dbdaea751" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/fnproject/cli"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install", "-v", "--force", "--skip-test"
      system "go", "build", "-o", "#{bin}/fn"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"
    assert_match version.to_s, shell_output("#{bin}/fn --version")
    system "#{bin}/fn", "init", "--runtime", "go", "--name", "myfunc"
    assert_predicate testpath/"func.go", :exist?, "expected file func.go doesn't exist"
    assert_predicate testpath/"func.yaml", :exist?, "expected file func.yaml doesn't exist"
    server = TCPServer.new("localhost", 0)
    port = server.addr[1]
    pid = fork do
      loop do
        socket = server.accept
        response = '{"route": {"path": "/myfunc", "image": "fnproject/myfunc"} }'
        socket.print "HTTP/1.1 200 OK\r\n" \
                    "Content-Length: #{response.bytesize}\r\n" \
                    "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end
    begin
      ENV["API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "/myfunc created with fnproject/myfunc"
      output = shell_output("#{bin}/fn routes create myapp myfunc")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.4.147.tar.gz"
  sha256 "77d54ba27bfb4946205f41dbadb3a3b099d2928d581dbc4bf182fcd3f1f14d11"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6ac4e2a30593095e9ac0851f8b6eb80172e3966bff63ad24adc3c448ef528eab" => :high_sierra
    sha256 "861d2c9e4a8f47252d6d26820b6e3333f19d208def305045ae73edc9edbf150c" => :sierra
    sha256 "e35d432cc4d21c219584e8a18f6b1d303d8a08ead2ae81fb56bca4ca3628f685" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/fnproject/cli"
    dir.install Dir["*"]
    cd dir do
      system "dep", "ensure", "-vendor-only"
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
      ENV["FN_API_URL"] = "http://localhost:#{port}"
      ENV["FN_REGISTRY"] = "fnproject"
      expected = "/myfunc created with fnproject/myfunc"
      output = shell_output("#{bin}/fn create routes myapp myfunc fnproject/myfunc:0.0.1")
      assert_match expected, output.chomp
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

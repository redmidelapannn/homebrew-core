class Fn < Formula
  desc "Command-line tool for the fn project"
  homepage "https://fnproject.io"
  url "https://github.com/fnproject/cli/archive/0.5.0.tar.gz"
  sha256 "99e6826e3e1a04024854d4c3b68c3bb7b661342b6d6bbcbf9dd7fc9600f8cbf1"

  bottle do
    cellar :any_skip_relocation
    sha256 "35f3dc41b6afbfcb47798d2a61a8ed7326f6e9cc2eaf4d03e49690521e6390e4" => :mojave
    sha256 "484fb33f10f5cb4dcf95aa24e1bef5f5f0fd1c8054953cb270e54eed0cf333e5" => :high_sierra
    sha256 "93174b08161c36a79a7815d23a81c33e0b8ee3723d0cdfdd9516dae343336b22" => :sierra
    sha256 "f90ec99a36548294cb26d9fb62a47ffd2810abd6d3b8f088057dc8d39638349d" => :el_capitan
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

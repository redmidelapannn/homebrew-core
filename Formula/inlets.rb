class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/inlets/inlets"
  url "https://github.com/inlets/inlets.git",
      :tag      => "2.7.0",
      :revision => "ced556795aecc6e2ac514032e78f3096d17bfa25"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "84f59ccdbf073566bed204d4d19b90b1212504ffef87a9f9ddd89dd6af935252" => :catalina
    sha256 "a6fe08da870da7d1ecf864d9424f208d6b3768ab0970400cfedbaf3ac4402f0c" => :mojave
    sha256 "c7abfccad97668278c6275c5c39cd0dd5a789d03a7b968a8bc164089f347e2e5" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "ruby" => :test

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/inlets/inlets").install buildpath.children
    cd "src/github.com/inlets/inlets" do
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X main.GitCommit=#{commit} -X main.Version=#{version}",
             "-a",
             "-installsuffix", "cgo", "-o", bin/"inlets"
      prefix.install_metafiles
    end
  end

  def cleanup(name, pid)
    puts "Tearing down #{name} on PID #{pid}"
    Process.kill("TERM", pid)
    Process.wait(pid)
  end

  test do
    upstream_port = free_port
    remote_port = free_port
    MOCK_RESPONSE = "INLETS OK".freeze
    SECRET_TOKEN = "itsasecret-sssshhhhh".freeze

    (testpath/"mock_upstream_server.rb").write <<~EOS
      require 'socket'

      server = TCPServer.new('localhost', #{upstream_port})

      loop do
        socket = server.accept
        request = socket.gets
        STDERR.puts request

        response = "OK\\n"
        shutdown = false

        if request.include? "inlets-test"
          response = "#{MOCK_RESPONSE}\\n"
          shutdown = true
        end

        socket.print "HTTP/1.1 200 OK\\r\\n" +
                    "Host: localhost:#{upstream_port}\\r\\n" +
                    "Content-Type: text/plain\\r\\n" +
                    "Content-Length: \#\{response.bytesize\}\\r\\n" +
                    "Connection: close\\r\\n"

        socket.print "\\r\\n"
        socket.print response
        socket.close

        if shutdown
          puts "Exiting test server"
          exit 0
        end
      end
    EOS

    mock_upstream_server_pid = fork do
      exec "ruby mock_upstream_server.rb"
    end

    begin
      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]

      # Basic --version test
      inlets_version = shell_output("#{bin}/inlets version")
      assert_match /\s#{commit}$/, inlets_version
      assert_match /\s#{version}$/, inlets_version

      # Client/Server e2e test
      # This test involves establishing a client-server inlets tunnel on the
      # remote_port, running a mock server on the upstream_port and then
      # testing that we can hit the mock server upstream_port via the tunnel remote_port
      sleep 3 # Waiting for mock server
      server_pid = fork do
        exec "#{bin}/inlets server --port #{remote_port} --token #{SECRET_TOKEN}"
      end

      client_pid = fork do
        # Starting inlets client
        exec "#{bin}/inlets client --remote localhost:#{remote_port} " \
             "--upstream localhost:#{upstream_port} --token #{SECRET_TOKEN}"
      end

      sleep 3 # Waiting for inlets websocket tunnel
      assert_match MOCK_RESPONSE, shell_output("curl -s http://localhost:#{remote_port}/inlets-test")
    ensure
      cleanup("Mock Server", mock_upstream_server_pid)
      cleanup("Inlets Server", server_pid)
      cleanup("Inlets Client", client_pid)
    end
  end
end

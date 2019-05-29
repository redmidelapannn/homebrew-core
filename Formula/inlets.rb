class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/alexellis/inlets"
  url "https://github.com/alexellis/inlets.git",
      :tag      => "2.0.3",
      :revision => "fc8ffa2067ae3a7751bc6ad9434c2186502469f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "487ff1607ae465b499880123308d35f5474d3b4f75edc34da93f4d2f77feafff" => :mojave
    sha256 "71c45836b6f9211b3fbacc7e3fe77b2e7d64937379833a245cdc1e2d8e6831e4" => :high_sierra
    sha256 "71bf1833be5f4c1bffb2bc10322eb4b34c354f63438669c7926cfd9cae5d6715" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/alexellis/inlets").install buildpath.children
    cd "src/github.com/alexellis/inlets" do
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X main.GitCommit=#{commit} -X main.Version=#{version}",
             "-a",
             "-installsuffix", "cgo", "-o", bin/"inlets"
      prefix.install_metafiles
    end
  end

  test do
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    puts "Listening on: #{port}"

    (testpath/"ws_server.rb").write <<~EOS
      require "socket"
      require "digest/sha1"

      server = TCPServer.new("127.0.0.1", #{port})
      websocket_port = server.addr[1]

      loop do
        socket = server.accept
        puts 'Incoming Request'

        http_request = ""
        while (line = socket.gets) && (line != "\\r\\n")
          http_request += line
        end

        if matches = http_request.match(/^Sec-WebSocket-Key: (\\S+)/)
          websocket_key = matches[1]
          puts "Websocket handshake detected with key: \#\{websocket_key\}"
        else
          puts "Ignoring non-websocket connection"
          next
        end

        response_key = Digest::SHA1.base64digest([websocket_key, "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].join)
        puts "Responding to handshake with key: \#\{response_key\}"

        response = "HTTP/1.1 101 Switching Protocols\\n" +
        "Upgrade: websocket\\n" +
        "Connection: Upgrade\\n" +
        "Sec-WebSocket-Accept: \#\{response_key\}\\n" +
        "\\n"

        socket.write response

        puts 'Handshake completed. Starting to parse the websocket frame.'

        count = 0
        loop do
          count += 1
          first_byte = socket.getbyte
          fin = first_byte & 0b10000000
          opcode = first_byte & 0b00001111

          second_byte = socket.getbyte
          is_masked = second_byte & 0b10000000
          payload_size = second_byte & 0b01111111

          keys = socket.read(4).bytes

          # Ping Message - see rfc6455
          if opcode == 9
            puts 'Received Ping'
            puts 'Sending Pong'
            output = [0b10001010, 0, ""]
            socket.write output.pack("CCA0")
          end

          # Exit after 2 ping-pongs
          if count == 2
            puts 'Exiting websocket server'
            exit 0
          end
        end
      end
    EOS

    pid = fork do
      exec "ruby ws_server.rb"
    end

    begin
      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]

      # Basic --version test
      inlets_version = shell_output("#{bin}/inlets --version")
      assert_match /\s#{commit}$/, inlets_version
      assert_match /\s#{version}$/, inlets_version

      # Client websocket ping-pong test
      sleep 3 # wait for server to start
      output = shell_output("#{bin}/inlets client -r 127.0.0.1:#{port} -u http://127.0.0.1:8080 -p 1s 2>&1")
      assert_match %r{\sUpstream:  => http://127.0.0.1:8080$}, output
      assert_match %r{\sconnecting to ws://127\.0\.0\.1:#{port}/tunnel with ping=1s$}, output
      assert_match /\sPing duration: 1.000000s$/, output
      assert_match /\sConnected to websocket: 127.0.0.1/, output

      ping_ping_count = output.scan(/PongHandler\. Extend deadline/).size
      assert_equal ping_ping_count, 2
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

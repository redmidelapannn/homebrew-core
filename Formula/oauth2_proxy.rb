class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v5.1.0.tar.gz"
  sha256 "571725356fa606a15ec198c618ee51ddb7583bc01b4b585d8117c64b98c2a341"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e7830bab1488d90a4284ad6d2d64e382064aed891bd3c9a1f38adfd8b91c220" => :catalina
    sha256 "15388e4db434fd4e6547dd27ab54ebf6653efb48ac70026591907536a82d28ff" => :mojave
    sha256 "28b1cb8287ec2d30c84f63803ca0e54240d1c1dd47d9e025b11e8affc39d0184" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=#{version}",
                          "-trimpath",
                          "-o", bin/"oauth2_proxy"
    (etc/"oauth2_proxy").install "contrib/oauth2_proxy.cfg.example"
    bash_completion.install "contrib/oauth2_proxy_autocomplete.sh" => "oauth2_proxy"
  end

  def caveats
    <<~EOS
      #{etc}/oauth2_proxy/oauth2_proxy.cfg must be filled in.
    EOS
  end

  plist_options :manual => "oauth2_proxy"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_bin}/oauth2_proxy</string>
              <string>--config=#{etc}/oauth2_proxy/oauth2_proxy.cfg</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    require "socket"
    require "timeout"

    # Get an unused TCP port.
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    pid = fork do
      exec "#{bin}/oauth2_proxy",
        "--client-id=testing",
        "--client-secret=testing",
        "--cookie-secret=testing",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=file:///tmp",
        "-email-domain=*"
    end

    begin
      Timeout.timeout(10) do
        loop do
          Utils.popen_read "curl", "-s", "http://127.0.0.1:#{port}"
          break if $CHILD_STATUS.exitstatus.zero?

          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

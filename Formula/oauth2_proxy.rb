class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://oauth2-proxy.github.io/oauth2-proxy/"
  url "https://github.com/oauth2-proxy/oauth2_proxy/archive/v5.1.0.tar.gz"
  sha256 "571725356fa606a15ec198c618ee51ddb7583bc01b4b585d8117c64b98c2a341"
  head "https://github.com/oauth2-proxy/oauth2-proxy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "813cd4c5e6efe1280fb450eea0e8958eca576989e9fdd5b007c54a4345797a41" => :catalina
    sha256 "3627e2fa429bd69b2de92e0c024914314b5626b113e5b29e670e88480ae231b9" => :mojave
    sha256 "794e4e7d96d1bc32dfeafacd2991c0a83be6ce866813c0f23447bdbeeb808495" => :high_sierra
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
    require "timeout"

    port = free_port

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

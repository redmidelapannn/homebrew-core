class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v1.0.5.tar.gz"
  sha256 "0e7dc07e4f61f9a00a4c962755098e19ebf8c8a8e0d72e311597ce021b7a2a5e"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e6cece46d847edf02381c8905ae9986713e1f719a6cdde32a8fa9936759faa81" => :catalina
    sha256 "4b5fd70c4ed01cb8e077f7b2e6896e1e301b6290e135ebabd81080e7dad898f5" => :mojave
    sha256 "deea86f0847fe70d66657db2df47f5cd08a9489d526fbab92556d59c8b8be98c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    (buildpath/"src/github.com/caddyserver").mkpath
    ln_s buildpath, "src/github.com/caddyserver/caddy"

    system "go", "build", "-ldflags",
           "-X github.com/caddyserver/caddy/caddy/caddymain.gitTag=#{version}",
           "-o", bin/"caddy", "github.com/caddyserver/caddy/caddy"
  end

  plist_options :manual => "caddy -conf #{HOMEBREW_PREFIX}/etc/Caddyfile"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/caddy</string>
            <string>-conf</string>
            <string>#{etc}/Caddyfile</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    begin
      io = IO.popen("#{bin}/caddy -port #{port}")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    io.read =~ /0\.0\.0\.0:#{port}/
  end
end

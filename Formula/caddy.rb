class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v1.0.0.tar.gz"
  sha256 "1c8b435a79e21b9832c7a8a88c44e70bc80434ca3719853d2b1092ffbbbbff7d"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02c9e762f95ec81f5305ae6db0be5e821fb01ab376a8fa64851badaac08a2004" => :mojave
    sha256 "3deb5530281a0f2257439d2d2b6ecce2c356dfdfdbf090447045d7ed6dc599a9" => :high_sierra
    sha256 "c67907fb7ba5fc35f980c5758cd4258414a4c2cc2dec9eff2d47a07caa76b2cc" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/mholt/caddy"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"caddy"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "caddy -conf #{HOMEBREW_PREFIX}/etc/Caddyfile"

  def plist; <<~EOS
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
    begin
      io = IO.popen("#{bin}/caddy")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    io.read =~ /0\.0\.0\.0:2015/
  end
end

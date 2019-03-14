class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38/archive/1.16.2.tar.gz"
  sha256 "230bfb01482fae505d510a602383b98a7cd3cd9f742e09063f537997f8df8a48"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13ef2e0d0d586ce150e4fb6835fb95c8223e312bdba068e4f12ff2ba98449bd3" => :mojave
    sha256 "4a328f57c8b24d28d8ccde94171a068fdfb8550071a118cd8e5a9572daa1a9aa" => :high_sierra
    sha256 "78ba8f80db57c272c47bee67685910a61fb610390761c3f6b0d776886e1401ec" => :sierra
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ENV["GOPATH"] = buildpath
    system "make"

    bin.install "tile38-cli", "tile38-server"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats; <<~EOS
    To connect: tile38-cli
  EOS
  end

  plist_options :manual => "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/tile38-server</string>
          <string>-d</string>
          <string>#{datadir}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/tile38.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/tile38.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/tile38-server", "-q"
      end
      sleep 2
      json_output = shell_output("#{bin}/tile38-cli server")
      tile38_server = JSON.parse(json_output)
      assert_equal tile38_server["ok"], true
    ensure
      Process.kill("HUP", pid)
    end
  end
end

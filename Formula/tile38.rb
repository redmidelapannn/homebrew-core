class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "http://tile38.com"
  url "https://github.com/tidwall/tile38/archive/1.12.0.tar.gz"
  sha256 "ca054d40109ff970fccd29efc425fc249b1824bf9dccfdc50e461d9e980ba014"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da8b8cc0ecc0552acb33be73ad3e9d104aa3827876732c36c3c2ba8d553fd3f8" => :high_sierra
    sha256 "a6d7cc766a5793976ca9c8d1411735c2cfd95a3bdc225a6757906dbf7283f6b0" => :sierra
    sha256 "6d134aea2f587a3e3d447eaa7527a213621880bd1e11e9690ae6a29197f7eb6e" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

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
    system bin/"tile38-cli", "-h"
  end
end

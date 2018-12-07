class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/v1.10.tar.gz"
  sha256 "923b1e195e168c2a91adcc75371231c26dcf23868ed3e0403cd4b1d662a52d59"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "48a950c9b9e693982397d8994ee01eb65dad0d1686c9e60889126bb9b59c9188" => :mojave
    sha256 "1b15f3b1b53f392b0254d7921a7ef27cab8257a6c334348ee8a2c7250e8c6cbb" => :high_sierra
    sha256 "42d3a2ff5d210bb79d3fa3d1d2e959723b5dcc9450e5d47a7efbc08b0d973e5b" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :manual => "beanstalkd"

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
          <string>#{opt_bin}/beanstalkd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/beanstalkd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/beanstalkd.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/beanstalkd", "-v"
  end
end

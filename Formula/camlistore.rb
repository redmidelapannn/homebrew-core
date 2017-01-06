class Camlistore < Formula
  desc "Content-addressable multi-layer indexed storage"
  homepage "https://camlistore.org"
  url "https://github.com/camlistore/camlistore.git",
      :tag => "0.9",
      :revision => "7b78c50007780643798adf3fee4c84f3a10154c9"
  head "https://camlistore.googlesource.com/camlistore", :using => :git

  bottle do
    rebuild 2
    sha256 "1934f24c5e4b7983991a7c3b4abbf489f291bde8d256ab5c744063cd5449b8c2" => :sierra
    sha256 "93792e6439e6a8fb7ef444609a32b7b22a97547cffde64e5562dfc10a8e30191" => :el_capitan
    sha256 "5dd67dd7a85be7a3b4ebc76a909a65a6611dc3464a197850a215407cd9369f39" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "go" => :build
  depends_on "sqlite"

  conflicts_with "hello", :because => "both install `hello` binaries"

  def install
    system "go", "run", "make.go"
    prefix.install "bin/README"
    prefix.install "bin"
  end

  plist_options :manual => "camlistored"

  def plist; <<-EOS.undent
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
        <string>#{opt_bin}/camlistored</string>
        <string>-openbrowser=false</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"camget", "-version"
  end
end

class Mpdas < Formula
  desc "C++ client to submit tracks to audioscrobbler"
  homepage "https://www.50hz.ws/mpdas/"
  url "https://www.50hz.ws/mpdas/mpdas-0.4.5.tar.gz"
  sha256 "c9103d7b897e76cd11a669e1c062d74cb73574efc7ba87de3b04304464e8a9ca"
  head "https://github.com/hrkfdn/mpdas.git"

  bottle do
    rebuild 1
    sha256 "8d72d2dd02df7765aa4000abe6db43f3f44d3f32b12bf948251324ebb5aed7ac" => :catalina
    sha256 "708ce4f8cf62da7d131c1e8b129303a0e44a8aa0e8b217fc16474bb0b6e4a0dc" => :mojave
    sha256 "2717fa6f461618b05fc76e0159ed4c16b6a5bf47f49f8298009ed2e8c73169a1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man1}", "CONFIG=#{etc}", "install"
    etc.install "mpdasrc.example"
  end

  plist_options :manual => "mpdas"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mpdas</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    system bin/"mpdas", "-v"
  end
end

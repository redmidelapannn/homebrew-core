class Launchdns < Formula
  desc "Mini DNS server designed solely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.3.tar.gz"
  sha256 "c34bab9b4f5c0441d76fefb1ee16cb0279ab435e92986021c7d1d18ee408a5dd"
  head "https://github.com/josh/launchdns.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ed880e50a48f87dfd11b7e55ae3e181b9bdf39ced7c761ae22b490f916791b15" => :yosemite
    sha256 "c2b42411d33437ee2cac305e924a86d467592e662aea63f5eb24a5c03f7bb3cc" => :sierra
    sha256 "939ae9c9ff911547238007c770f6b90d9830f05d3d045cd9a0326c51f67de4c3" => :el_capitan
  end

  depends_on :macos => :yosemite

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "--with-launch-h", "--with-launch-h-activate-socket"
    system "make", "install"

    (prefix/"etc/resolver/dev").write("nameserver 127.0.0.1\nport 55353\n")
  end

  def caveats; <<-EOS.undent
    To have *.dev resolved to 127.0.0.1:
      sudo ln -s #{HOMEBREW_PREFIX}/etc/resolver /etc
    EOS
  end

  plist_options :manual => "launchdns"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/launchdns</string>
          <string>--socket=Listeners</string>
          <string>--timeout=30</string>
        </array>
        <key>Sockets</key>
        <dict>
          <key>Listeners</key>
          <dict>
            <key>SockType</key>
            <string>dgram</string>
            <key>SockNodeName</key>
            <string>127.0.0.1</string>
            <key>SockServiceName</key>
            <string>55353</string>
          </dict>
        </dict>
        <key>StandardErrorPath</key>
        <string>#{var}/log/launchdns.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/launchdns.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    output = shell_output("#{bin}/launchdns --version")
    assert_no_match(/without socket activation/, output)
    system bin/"launchdns", "-p0", "-t1"
  end
end

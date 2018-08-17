class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.3.9.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.3.9.tar.gz"
  sha256 "85346b4d026e6a041c8e326d2cc64b5f5361b032075c89c5854f16dbc02fce6f"

  bottle do
    rebuild 1
    sha256 "92f5e74f8de41a093ecc5f67a69291b8bfbb9f9bc8b589949f683519cb0ea0d3" => :high_sierra
    sha256 "d36ee995e900d0888ff224f54c755206ce6a20a8f657383477d96ec7090868c2" => :sierra
    sha256 "e106b00bcc0656831677d9d836a973bf1be21727c5da05264a2266a46c856190" => :el_capitan
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.4.6-rc.tar.gz"
    sha256 "37fee64793ebb1da4abad379f63150f80482ac760da9beac9b5f83baabf93ed0"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl"
  depends_on "libscrypt" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-openssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--disable-libscrypt" if build.without? "libscrypt"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "tor"

  def plist; <<~EOS
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
            <string>#{opt_bin}/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/tor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/tor.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    pipe_output("script -q /dev/null #{bin}/tor-gencert --create-identity-key", "passwd\npasswd\n")
    assert_predicate testpath/"authority_certificate", :exist?
    assert_predicate testpath/"authority_signing_key", :exist?
    assert_predicate testpath/"authority_identity_key", :exist?
  end
end

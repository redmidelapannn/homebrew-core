class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://tor.eff.org/dist/tor-0.3.1.8.tar.gz"
  mirror "https://www.torproject.org/dist/tor-0.3.1.8.tar.gz"
  sha256 "7df6298860a59f410ff8829cf7905a50c8b3a9094d51a8553603b401e4b5b1a1"

  bottle do
    rebuild 1
    sha256 "c9911530783aa67dddaee9944e4fc1bc87eb740a0e7aaa38e5d4f8f589184772" => :high_sierra
    sha256 "496d33aaa1b1f23d9ef67d09bb6df3732679faeb8b0b2544ec22ac0b9db872ab" => :sierra
    sha256 "3f5ade105b85e9e76257b07a9363de1889b290a3c0208a5b75a52771b685eec8" => :el_capitan
  end

  devel do
    url "https://tor.eff.org/dist/tor-0.3.2.3-alpha.tar.gz"
    mirror "https://www.torproject.org/dist/tor-0.3.2.3-alpha.tar.gz"
    sha256 "1440a4bf6d52cb9831991af6ae7a0fc1c152af59108c9dff6b036e70e3641d19"
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

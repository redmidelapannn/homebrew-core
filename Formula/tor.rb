class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://tor.eff.org/dist/tor-0.3.1.8.tar.gz"
  mirror "https://www.torproject.org/dist/tor-0.3.1.8.tar.gz"
  sha256 "7df6298860a59f410ff8829cf7905a50c8b3a9094d51a8553603b401e4b5b1a1"

  bottle do
    rebuild 1
    sha256 "ec18ad4a6b42a6c8e899a20190afb5345010a6390bcfcf5fac40655778b96664" => :high_sierra
    sha256 "a610193a803b6802990159136e07f5c05877f2229f692bb7f971cc3e6230055d" => :sierra
    sha256 "299fb42ad1b74be41202fbaeee2fe13e0389c4c5fcf6b5de2f8e102f41d155f2" => :el_capitan
  end

  devel do
    url "https://tor.eff.org/dist/tor-0.3.2.4-alpha.tar.gz"
    mirror "https://www.torproject.org/dist/tor-0.3.2.4-alpha.tar.gz"
    sha256 "c3ea7826b783d4357a624248d8448480f27838ceb3c1bba02a4a0e5d36564fba"
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

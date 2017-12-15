class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://tor.eff.org/dist/tor-0.3.1.9.tar.gz"
  mirror "https://www.torproject.org/dist/tor-0.3.1.9.tar.gz"
  sha256 "6e1b04f7890e782fd56014a0de5075e4ab29b52a35d8bca1f6b80c93f58f3d26"

  bottle do
    rebuild 1
    sha256 "a5262f8d6831701f492b9bdb323b7897ea6d1e92becdee977cea1940d51bd4ce" => :high_sierra
    sha256 "59288da8d19e4a6c06f759dd692eecb83a0b79215e8b63a9c0078755216e0680" => :sierra
    sha256 "376be6e893679ef09919311d81a932b17944d05caeff01c53cb35b5fffd4125d" => :el_capitan
  end

  devel do
    url "https://tor.eff.org/dist/tor-0.3.2.7-rc.tar.gz"
    mirror "https://www.torproject.org/dist/tor-0.3.2.7-rc.tar.gz"
    sha256 "4be673a5084790977d692e11afe5ca575adb08f06809dbac52d8b005435131fb"
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

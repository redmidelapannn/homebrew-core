class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.3.7.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.3.7.tar.gz"
  sha256 "ea6bb512c4adfbc4e05b22e4c2d06bddff5b358a53de982273fec846b75bde0c"

  bottle do
    rebuild 1
    sha256 "3497832e2c0e09a1d9ec8c77d794b0ee8a2966502d7b16a978ae1b39ce9740cf" => :high_sierra
    sha256 "cabebcbb3aa87510fcdc6e84fe6c69291e67d95ad9b0ade5faf94ff02f6f7552" => :sierra
    sha256 "909d46c4dccf9adaa51d50f4c54e21cc7499b561479cfb4fb1e0585e57947f44" => :el_capitan
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.4.2-alpha.tar.gz"
    sha256 "37b7f675ccee4478fe4d1ec964e8925782e9d4cdf36ed2a782de12732f47e35a"
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.4.2-alpha.tar.gz"
    sha256 "37b7f675ccee4478fe4d1ec964e8925782e9d4cdf36ed2a782de12732f47e35a"
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

class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.4.8.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.4.8.tar.gz"
  sha256 "826a4cb2c099a29c7cf91516ffffcfcb5aace7533b8853a8c8bddcfe2bfb1023"

  bottle do
    rebuild 1
    sha256 "8bf0a7600d0d3a00d86750d7e79f050514fd7b81f0ded402be2e7808bdb0e988" => :mojave
    sha256 "f83046f0a99c9534a787442356c0ada6429c2ce32d369da980ba4f05e2e162df" => :high_sierra
    sha256 "5728bb30057d6c72b68f8f30124d94592b2b420a88e330f60b62061f3ec0f2e3" => :sierra
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.5.3-alpha.tar.gz"
    sha256 "b5889b17062a20c1d28b5ddf8872818584a2ff1a5ebaeb37493f7699e3c37db4"
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

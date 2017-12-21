class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.1.9.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.1.9.tar.gz"
  sha256 "6e1b04f7890e782fd56014a0de5075e4ab29b52a35d8bca1f6b80c93f58f3d26"

  bottle do
    rebuild 1
    sha256 "8fe9be843c4b02fa070e637a67ba9dd913cc82c656f188b900fec17de4c66178" => :high_sierra
    sha256 "0c959eedb6a0bf7bc6f8fc1d3212cb2ea910eb89839e0f6df0853af5c528eb31" => :sierra
    sha256 "5d4c2f2e7d24b3aa7fc0a745f54763b26ae49f1ab4011934a133880220848887" => :el_capitan
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.2.8-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.3.2.8-rc.tar.gz"
    sha256 "09ee4578f6189f9ec8444bdfd77da65249787537c5661ce746e52aa6b08a0df7"
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

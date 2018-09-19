class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.4.8.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.4.8.tar.gz"
  sha256 "826a4cb2c099a29c7cf91516ffffcfcb5aace7533b8853a8c8bddcfe2bfb1023"

  bottle do
    rebuild 1
    sha256 "831439f5baca910b95872e6587ae8c43c25c016f03b1b3edb6436b034bc738b5" => :mojave
    sha256 "cb25126e89f475918f8d221b418cc81eb8c1a1eaac9e846c31045ed185e803fc" => :high_sierra
    sha256 "f42ef4701ac9a9a64e737182107fb1f7703d087412109ace5926508057fadfbf" => :sierra
    sha256 "f07d1679ffb7c59d91ca7f02d699f50a606fe982ff0c2b054b8bb5cd314009a2" => :el_capitan
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.5.1-alpha.tar.gz"
    sha256 "46146e0fa7a957136bd324889082315911ea3d1b6d2e7eadd2338a64e8b95bc7"
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

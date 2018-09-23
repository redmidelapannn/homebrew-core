class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.4.8.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.4.8.tar.gz"
  sha256 "826a4cb2c099a29c7cf91516ffffcfcb5aace7533b8853a8c8bddcfe2bfb1023"

  bottle do
    rebuild 1
    sha256 "a6503d0c2a5c1634b30bab48764e91d13634556b48d55e300eb96cb6ce1d2284" => :mojave
    sha256 "6c4b0031249bc91c7e458c20879968396712d3cb78b5295b045719fe19f18479" => :high_sierra
    sha256 "4c1fe55f70037d087227f17b0af12eb58c370444ac43ba60ac03e22cdd0dfed9" => :sierra
    sha256 "e4dcf12f1b14c4267b8779040caabec78e849a6a2ebfb89e3f476fd606563e9b" => :el_capitan
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.5.2-alpha.tar.gz"
    sha256 "a4d75d8bcf9e357e47528da773039d796a98d00c50a3b5ab7d9b92aa744aec9a"
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

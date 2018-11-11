class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.4.9.tar.gz"
  mirror "https://www.torservers.net/mirrors/torproject.org/dist/tor-0.3.4.9.tar.gz"
  sha256 "1a171081f02b9a6ff9e28c0898defb7670e5bbb3bdbcaddfcf4e4304aedd164a"

  bottle do
    rebuild 1
    sha256 "b38ef759d16a252c71ef786fcdcd16e0a5b46eb563f2ba23ab5d0aba7ee31b6b" => :mojave
    sha256 "f71b74f13b9fa977e15f397739eef561bb62374c52df44cb1ac2796cd487c18d" => :high_sierra
    sha256 "d8fc283cdda8e9f2b1c8fe05e87c98920b0a55a15aee130edcb9d6a52143fbb0" => :sierra
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.5.4-alpha.tar.gz"
    sha256 "0f026b5f5a11ce67efd5e2cad091f8538bc8c895ad4b4404737d0418c5434078"
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

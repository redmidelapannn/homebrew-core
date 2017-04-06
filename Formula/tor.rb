class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.9.10.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.9.10.tar.gz"
  sha256 "d611283e1fb284b5f884f8c07e7d3151016851848304f56cfdf3be2a88bd1341"

  bottle do
    rebuild 1
    sha256 "56bd70610b2d7b000022804a43e2af3da8e3ad5e8b73bca63186ca8af10d4686" => :sierra
    sha256 "d291355e66fd3ccf4c263858d7b4df89d75564d66ce0d1060a00445cb7f578a6" => :el_capitan
    sha256 "893dbc4a32383f50dee3859997ca5568fe2a9c72215cb4cbc32760f6bcc9f595" => :yosemite
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.0.5-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.3.0.5-rc.tar.gz"
    sha256 "622c9366d8b753da9192e037d0a13d2d87ffec25b5c606a3d73a2452976b43e0"
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

  def plist; <<-EOS.undent
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
    assert (testpath/"authority_certificate").exist?
    assert (testpath/"authority_signing_key").exist?
    assert (testpath/"authority_identity_key").exist?
  end
end

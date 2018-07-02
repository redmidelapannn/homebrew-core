class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.3.3.7.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.3.3.7.tar.gz"
  sha256 "ea6bb512c4adfbc4e05b22e4c2d06bddff5b358a53de982273fec846b75bde0c"

  bottle do
    rebuild 1
    sha256 "ea11beef495cedda7e71eefb4b925f9d7779a72e50297f999911685bafe3399b" => :high_sierra
    sha256 "3d96caed820c0748112e056ee6ff25e99899d40331978b4412a62f29d16773af" => :sierra
    sha256 "428944fe1e0240a160ba71bc40fdc3c1f8c5754108203489bc0e0220ebef6bd9" => :el_capitan
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.3.4.3-alpha.tar.gz"
    sha256 "ba691d61557a8a978dfb8851d01de4d50bc2b31de0d344e2f914f8c668f28b15"
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

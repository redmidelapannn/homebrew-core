class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.11.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.11.tar.gz"
  sha256 "7adea0bfa17edafd4e09453f4f58a0dca737660e5358f9dafd52d55d55dc6ab3"

  bottle do
    rebuild 1
    sha256 "5edf22e7f42bf8a3b0bc71c477ed87de666917f41d6dee92c20c8f6203d3af28" => :sierra
    sha256 "496572453032423b28f3338ef69c9e56d988d0a0053ad19e51785812d5444899" => :el_capitan
    sha256 "cd1f87cb60a7f3f8efe099692a47677dc8e57065950aaadbac072b71c317b53f" => :yosemite
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.2.9.7-rc.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.9.7-rc.tar.gz"
    sha256 "0e73c18afd5f1d0cc60f2bba1ac7bd5b64ae984a41dfcbbb06897dc5843b68d0"
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

  def caveats; <<-EOS.undent
    You will find a sample `torrc` file in #{etc}/tor.
    It is advisable to edit the sample `torrc` to suit
    your own security needs:
      https://www.torproject.org/docs/faq#torrc
    After editing the `torrc` you need to restart tor.
    EOS
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

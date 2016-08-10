class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.6.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.6.tar.gz"
  sha256 "3dc9fc02f7cd22ed5fce707e0d9b26a72b1bd0976766a804cb13078d32e3ab5a"

  bottle do
    revision 1
    sha256 "335fbddb2558ca8a3dba96bf8cc0f56f246eb9f7194f2c7886053592b397a6c1" => :el_capitan
    sha256 "cb12cd2ca515d639e169f56cd76d19a050f6c71cbed4e3c62d1855cf476a7b60" => :yosemite
    sha256 "7e5ee6b47d92fd2468cd3a251cf4839f16b43f6e5926d56295625c4bef5b02cc" => :mavericks
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.9.1-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.9.1-alpha.tar.gz"
    version "0.2.9.1-alpha"
    sha256 "1a1b57af6bb47ecb62e4c60e2ceecb5609b558b1fdd87c86a91571d1601ba3f2"
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

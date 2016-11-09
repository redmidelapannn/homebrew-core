class Tor < Formula
  desc "Anonymizing overlay network for TCP"
  homepage "https://www.torproject.org/"
  url "https://dist.torproject.org/tor-0.2.8.9.tar.gz"
  mirror "https://tor.eff.org/dist/tor-0.2.8.9.tar.gz"
  sha256 "3f5c273bb887be4aff11f4d99b9e2e52d293b81ff4f6302b730161ff16dc5316"

  bottle do
    rebuild 1
    sha256 "c62b8568075f11f2c009f3ca2bb4ca10eef1d8a49b25c47c708153d0ee6eef46" => :sierra
    sha256 "b87bd1c8ae9f28adad5187af46721a7d6301a4d9a06b43207d9312d8b44d17a7" => :el_capitan
    sha256 "203479b5f726a5cef0206241354ba7156469c39f3bf9bb8ddeabb3d1bce6c69a" => :yosemite
  end

  devel do
    url "https://dist.torproject.org/tor-0.2.9.5-alpha.tar.gz"
    mirror "https://tor.eff.org/dist/tor-0.2.9.5-alpha.tar.gz"
    sha256 "d0c898ad5e8f1a136864aa105407c7b89f3e70d9462a7bb307a55a3afa5b62bd"
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

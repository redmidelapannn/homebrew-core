class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.28/ircd-hybrid-8.2.28.tgz"
  sha256 "054eca889cedbf49f1fc1d9627a7419a5862cdca1ee77debe5968d5e198940c9"

  bottle do
    sha256 "18ef6efa584729f6261c0e5f75e1aacf5c4b9c253bf6b507d923fe2bea37c5ae" => :catalina
    sha256 "0e15b0369df6939fe8316927230fb8defff0d41966776565508fd34fca0533db" => :mojave
    sha256 "dd893c5a24b793ab21392be69d435207f5a16a77bf75d1b3bccdc204dbab5795" => :high_sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "ircd-irc2", :because => "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats; <<~EOS
    You'll more than likely need to edit the default settings in the config file:
      #{etc}/ircd.conf
  EOS
  end

  plist_options :manual => "ircd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <false/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/ircd</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/ircd.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/ircd", "-version"
  end
end

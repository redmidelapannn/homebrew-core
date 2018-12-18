class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://github.com/mikebrady/shairport-sync/archive/3.2.2.tar.gz"
  sha256 "4f1ee142b887842727ae0c310e21c83ea2386518e841a25c7ddb015d08b54eba"
  head "https://github.com/mikebrady/shairport-sync.git", :branch => "development"

  bottle do
    rebuild 1
    sha256 "9b2c9eb1276a738e22b27312541e9cd58d7ad0399b061a19abc726a246f7185c" => :mojave
    sha256 "daea28aa2c891d268e477527b7adefa3469522cf065e074cf935a2d9cabeb09f" => :high_sierra
    sha256 "f54ab3e56a717d88e6434e4acc3f6f9f6982dd202ed6292e4f160f41cd99482f" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl"
  depends_on "popt"

  def install
    system "autoreconf", "-fvi"
    args = %W[
      --with-os=darwin
      --with-ssl=openssl
      --with-dns_sd
      --with-ao
      --with-stdout
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{etc}/shairport-sync
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run").mkpath
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V", 1)
    assert_match "OpenSSL-ao-stdout-pipe-soxr-metadata", output
  end
  
  plist_options :manual => "shairport-sync"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
      <string>#{opt_bin}/shairport-sync</string>
      <string>-d</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

end

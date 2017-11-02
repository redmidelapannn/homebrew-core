class PureFtpd < Formula
  desc "Secure and efficient FTP server"
  homepage "https://www.pureftpd.org/"
  url "https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  mirror "https://fossies.org/linux/misc/pure-ftpd-1.0.46.tar.gz"
  mirror "https://ftp.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.46.tar.gz"
  sha256 "0609807335aade4d7145abdbb5cb05c9856a3e626babe90658cb0df315cb0a5c"
  revision 1

  bottle do
    rebuild 1
    sha256 "7d2359369ebcabda4872861371c7bb463f821148f9bb7e9a5c0b9d108794082a" => :high_sierra
    sha256 "281e81d17d27ec7e3f9b6c37dc8b2af41e290018dc83746e9753edc1a4a19b1b" => :sierra
    sha256 "802eabcf4d6aed7ac9dd34b9a6d3df00223741ab69ac671fe2af71eb98c28ce0" => :el_capitan
  end

  option "with-virtualchroot", "Follow symbolic links even for chrooted accounts"

  depends_on "libsodium"
  depends_on "openssl"
  depends_on :postgresql => :optional
  depends_on :mysql => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-everything
      --with-pam
      --with-tls
      --with-bonjour
    ]

    args << "--with-pgsql" if build.with? "postgresql"
    args << "--with-mysql" if build.with? "mysql"
    args << "--with-virtualchroot" if build.with? "virtualchroot"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "pure-ftpd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/pure-ftpd</string>
          <string>--chrooteveryone</string>
          <string>--createhomedir</string>
          <string>--allowdotfiles</string>
          <string>--login=puredb:#{etc}/pureftpd.pdb</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pure-ftpd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/pure-ftpd.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"pure-pw", "--help"
  end
end

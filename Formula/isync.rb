class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.3.0/isync-1.3.0.tar.gz"
  sha256 "8d5f583976e3119705bdba27fa4fc962e807ff5996f24f354957178ffa697c9c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "1d43bceb28d9d9f98716bc62a8b5f89270bf67efc575fcfe0a8f04e9bd94308e" => :mojave
    sha256 "e788500f962e75040bb42c77b900665ac72343591543e173a21c5a1a5de252f1" => :high_sierra
    sha256 "5daf76ead5795b2586a2bcb60c1aafe0163f2feaa49cb899a01052203c562477" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/isync/isync.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "berkeley-db"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "isync"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/mbsync</string>
          <string>-a</string>
        </array>
        <key>StartInterval</key>
        <integer>300</integer>
        <key>RunAtLoad</key>
        <true />
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system bin/"mbsync-get-cert", "duckduckgo.com:443"
  end
end

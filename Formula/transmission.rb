class Transmission < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://www.transmissionbt.com/"
  url "https://download.transmissionbt.com/files/transmission-2.92.tar.xz"
  sha256 "3a8d045c306ad9acb7bf81126939b9594553a388482efa0ec1bfb67b22acd35f"

  bottle do
    revision 1
    sha256 "7aae6f907fa0dcd303132630a06712a129653f83047891b5dc7a5a6d57ddc5f3" => :el_capitan
    sha256 "ba02d517080ff34af6fdd0fdf8030ec3ee91a20415e10df3ac9645c8bd7b5891" => :yosemite
    sha256 "2e47123f52a9e01d682b29e1244f538d327ab883fbf9d66a1ab980d84c1e3bfc" => :mavericks
  end

  option "with-nls", "Build with native language support"

  depends_on "pkg-config" => :build
  depends_on "curl" if MacOS.version <= :leopard
  depends_on "libevent"

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext"
  end

  def install
    ENV.append "LDFLAGS", "-framework Foundation -prebind"
    ENV.append "LDFLAGS", "-liconv"

    args = %W[--disable-dependency-tracking
              --prefix=#{prefix}
              --disable-mac
              --without-gtk]

    args << "--disable-nls" if build.without? "nls"

    system "./configure", *args
    system "make", "install"

    (var/"transmission").mkpath
  end

  def caveats; <<-EOS.undent
    This formula only installs the command line utilities.

    Transmission.app can be downloaded directly from the website:
      https://www.transmissionbt.com/

    Alternatively, install with Homebrew-Cask:
      brew cask install transmission
    EOS
  end

  plist_options :manual => "transmission-daemon --foreground"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/transmission-daemon</string>
          <string>--foreground</string>
          <string>--config-dir</string>
          <string>#{var}/transmission/</string>
          <string>--log-info</string>
          <string>--logfile</string>
          <string>#{var}/transmission/transmission-daemon.log</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/transmission-create", "-o", "#{testpath}/test.mp3.torrent", test_fixtures("test.mp3")
    assert_match /^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent")
  end
end

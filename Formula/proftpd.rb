class Proftpd < Formula
  desc "Highly configurable GPL-licensed FTP server software"
  homepage "http://www.proftpd.org/"
  url "ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.5a.tar.gz"
  sha256 "a1f48df8539c414ec56e0cea63dcf4b8e16e606c05f10156f030a4a67fae5696"

  bottle do
    rebuild 1
    sha256 "e09b0e757fb05a44178d220e8c01f7445f7ab9a4da6f29210b7892657ede0b2e" => :sierra
    sha256 "5856518a500504d0e98b1f58f09c6c44444f309fa35a5ef9e552209ed00c3214" => :el_capitan
    sha256 "ede4594a60a893914f573b99ca6093499e61fa1c605ba5bb8596c6afe46a726b" => :yosemite
  end

  def install
    # fixes unknown group 'nogroup'
    # http://www.proftpd.org/docs/faq/linked/faq-ch4.html#AEN434
    inreplace "sample-configurations/basic.conf", "nogroup", "nobody"

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    ENV.deparallelize
    install_user = ENV["USER"]
    install_group = `groups`.split[0]
    system "make", "INSTALL_USER=#{install_user}", "INSTALL_GROUP=#{install_group}", "install"
  end

  plist_options :manual => "proftpd"

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
        <false/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/proftpd</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{opt_sbin}/proftpd -v")
  end
end

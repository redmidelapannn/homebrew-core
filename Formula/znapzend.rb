class Znapzend < Formula
  desc "ZFS backup with remote capabilities and mbuffer integration"
  homepage "https://www.znapzend.org/"
  url "https://github.com/oetiker/znapzend/releases/download/v0.19.1/znapzend-0.19.1.tar.gz"
  sha256 "93e3ec3c6f5cdf6973f72a6b764c49dc6545f2a0a2e0267a1382d471b930efea"
  head "https://github.com/oetiker/znapzend.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "59649be8551cba6609da1275439558058d50eae20b744a8ca7eba5d7d3e42bd6" => :high_sierra
    sha256 "c17d390b44007b7795a8aa8448d37c26e68dc2414c9c2f67c648c20b363aaf99" => :sierra
    sha256 "ebccbffa2c7f5018f1a9ce19cd1b89f9d26abc20f524d061ea7105fb77c3e5bd" => :el_capitan
  end

  depends_on "perl" if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (var/"log/znapzend").mkpath
    (var/"run/znapzend").mkpath
  end

  plist_options :startup => true, :manual => "sudo znapzend --daemonize"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PATH</key>
          <string>/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:#{HOMEBREW_PREFIX}/bin</string>
        </dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/znapzend</string>
          <string>--connectTimeout=120</string>
          <string>--logto=#{var}/log/znapzend/znapzend.log</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/znapzend/znapzend.err.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/znapzend/znapzend.out.log</string>
        <key>ThrottleInterval</key>
        <integer>30</integer>
        <key>WorkingDirectory</key>
        <string>#{var}/run/znapzend</string>
      </dict>
    </plist>
  EOS
  end

  test do
    fake_zfs = testpath/"zfs"
    fake_zfs.write <<~EOS
      #!/bin/sh
      for word in "$@"; do echo $word; done >> znapzendzetup_said.txt
      exit 0
    EOS
    chmod 0755, fake_zfs
    ENV.prepend_path "PATH", testpath
    system "#{bin}/znapzendzetup", "list"
    assert_equal <<~EOS, (testpath/"znapzendzetup_said.txt").read
      list
      -H
      -o
      name
      -t
      filesystem,volume
    EOS
  end
end

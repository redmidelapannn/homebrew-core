class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v20.1.tar.gz"
  sha256 "feea3e3884f66731b5efe3d289d5215ad4be27acb6a5879fabed14246f649cd7"
  head "https://github.com/cjdelisle/cjdns.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6940445baa5b02e101b10b153d53f9c0a956f510b26c78575f476fa87c7b7ab3" => :high_sierra
  end

  depends_on "node" => :build

  def install
    system "./do"
    bin.install "cjdroute"
    (pkgshare/"test").install "build_darwin/test_testcjdroute_c" => "cjdroute_test"
  end

  def post_install
    `#{bin}/cjdroute --genconf > #{HOMEBREW_PREFIX}/etc/cjdroute.conf`
    inreplace "#{HOMEBREW_PREFIX}/etc/cjdroute.conf",
      '"noBackground":0',
      '"noBackground":1'
  end

  plist_options :startup => true, :manual => "cjdroute < #{HOMEBREW_PREFIX}/etc/cjdroute.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/cjdroute</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardInPath</key>
        <string>#{HOMEBREW_PREFIX}/etc/cjdroute.conf</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/cjdroute.log</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/cjdroute.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{pkgshare}/test/cjdroute_test", "all"
  end
end

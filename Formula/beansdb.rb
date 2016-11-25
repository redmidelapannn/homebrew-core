class Beansdb < Formula
  desc "Yet another distributed key-value storage system"
  homepage "https://github.com/douban/beansdb"
  url "https://github.com/douban/beansdb/archive/v0.6.tar.gz"
  sha256 "b24512862f948d5191f5c43316a41f632bc386f43dcbb69b03ffffe95122a33e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c08a84f91da5f8d5ae76493ed77bd586c514000d7d2eff43a2d733f1179dc276" => :sierra
    sha256 "a793579fceae8f5e601337668ca85d79841d839018fe0a34ba8aa52a37dadcc7" => :el_capitan
    sha256 "e3fd62a9a9cfa59efc5504c4f9f1f74713351104dbb19b3083d78b13a6d73c8b" => :yosemite
  end

  head do
    url "https://github.com/douban/beansdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    (var/"db/beansdb").mkpath
    (var/"log").mkpath
  end

  plist_options :manual => "beansdb"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>SuccessfulExit</key>
        <false/>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/beansdb</string>
        <string>-p</string>
        <string>7900</string>
        <string>-H</string>
        <string>#{var}/db/beansdb</string>
        <string>-T</string>
        <string>1</string>
        <string>-vv</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/beansdb.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/beansdb.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/beansdb", "-h"
  end
end

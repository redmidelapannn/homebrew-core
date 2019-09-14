class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://pgbouncer.github.io/"
  url "https://pgbouncer.github.io/downloads/files/1.10.0/pgbouncer-1.10.0.tar.gz"
  sha256 "d8a01442fe14ce3bd712b9e2e12456694edbbb1baedb0d6ed1f915657dd71bd5"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "7b784d04c21ea70494cbf42cdec903f01cc9cf344d33e10889f0ab87e6168ca3" => :mojave
    sha256 "7b2ea7b500518ce27e063c1bc7b0268100d196982c6fe29c244bf5cc0c23a39a" => :high_sierra
    sha256 "34f07b4f08b75d911fcd5d49efb700662473f538541f2f3a75f8ba463458ef8d" => :sierra
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--with-libevent=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    ln_s "../install-sh", "doc/install-sh"
    system "make", "install"
    bin.install "etc/mkauth.py"
    inreplace "etc/pgbouncer.ini" do |s|
      s.gsub! /logfile = .*/, "logfile = #{var}/log/pgbouncer.log"
      s.gsub! /pidfile = .*/, "pidfile = #{var}/run/pgbouncer.pid"
      s.gsub! /auth_file = .*/, "auth_file = #{etc}/userlist.txt"
    end
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
  end

  def caveats; <<~EOS
    The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
    will need to edit it for your particular setup. See:
    https://pgbouncer.github.io/config.html

    The auth_file option should point to the #{etc}/userlist.txt file which
    can be populated by the #{bin}/mkauth.py script.
  EOS
  end

  plist_options :manual => "pgbouncer -q #{HOMEBREW_PREFIX}/etc/pgbouncer.ini"

  def plist
    <<~EOS
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
          <string>#{opt_bin}/pgbouncer</string>
          <string>-q</string>
          <string>#{etc}/pgbouncer.ini</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgbouncer -V")
  end
end

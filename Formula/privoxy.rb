class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.28%20%28stable%29/privoxy-3.0.28-stable-src.tar.gz"
  sha256 "b5d78cc036aaadb3b7cf860e9d598d7332af468926a26e2d56167f1cb6f2824a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f16a7ffadfd556b2927956f672f796eb074ef676a084a86f0f1c0d713d639052" => :catalina
    sha256 "b6f9589db36e833ed7a9cb9df6544b5d64c58e94eacd3e065c56064c47d668b1" => :mojave
    sha256 "c5e6c1e5b2e1d3aa3d02a89b91e9bb060b01276cab177087d71054810f24108e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    # Find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  plist_options :manual => "privoxy #{HOMEBREW_PREFIX}/etc/privoxy/config"

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
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/privoxy</string>
          <string>--no-daemon</string>
          <string>#{etc}/privoxy/config</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/privoxy/logfile</string>
      </dict>
      </plist>
    EOS
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"config").write("listen-address #{bind_address}\n")
    begin
      server = IO.popen("#{sbin}/privoxy --no-daemon #{testpath}/config")
      sleep 1
      assert_match "200 OK", shell_output("/usr/bin/curl -I -x #{bind_address} https://github.com")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end

class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.26%20%28stable%29/privoxy-3.0.26-stable-src.tar.gz"
  sha256 "57e415b43ee5dfdca74685cc034053eaae962952fdabd086171551a86abf9cd8"

  bottle do
    cellar :any
    rebuild 2
    sha256 "1f231cd6fdece109e21c02e03541b22e618bc760590a36cda38b82f8618e869b" => :sierra
    sha256 "da0f9ea72a705bce86c38c79e1f97c7ecf83c8c6f141226fbf1cd057439594cc" => :el_capitan
    sha256 "7f8d9b713b06733eac388c37de71905e2ba51171f06f528a111cae8404b76483" => :yosemite
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

  def plist; <<-EOS.undent
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
    bind_address = "127.0.0.1:8118"
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

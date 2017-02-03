class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz"
  sha256 "66383b7d367de25ba031d37762d83e2b55de010c573009c6f58270b137131072"
  revision 1

  bottle do
    cellar :any
    rebuild 3
    sha256 "afaf33e55908a2d60b1b912dc7aa1573da4271c3bf4c203b60d3ec0ef541c71f" => :sierra
    sha256 "2cf6df63131f221c70e8a0c509d61072ef403f01610482fcef5beee3d5d41d86" => :el_capitan
    sha256 "c447113a8d68ef1d3d52c991a028d7568f474d1c2d6be3513f5cb27264895c5b" => :yosemite
  end

  depends_on "nagios-plugins"
  depends_on "openssl"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    (var/"run").mkpath
    inreplace "sample-config/nrpe.cfg.in", "/var/run/nrpe.pid", var/"run/nrpe.pid"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin",
                          "--sysconfdir=#{etc}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl"].opt_lib}",
                          "--enable-ssl",
                          "--enable-command-args"

    inreplace "src/Makefile", "$(LIBEXECDIR)", "$(SBINDIR)"

    system "make", "all"
    system "make", "install"
    system "make", "install-daemon-config"
  end

  plist_options :manual => "nrpe -n -c #{HOMEBREW_PREFIX}/etc/nrpe.cfg -d"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>org.nrpe.agent</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/nrpe</string>
        <string>-c</string>
        <string>#{etc}/nrpe.cfg</string>
        <string>-d</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>ServiceDescription</key>
      <string>Homebrew NRPE Agent</string>
      <key>Debug</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/nrpe", "-n", "-c", "#{etc}/nrpe.cfg", "-d"
    end
    sleep 2

    begin
      output = shell_output("netstat -an")
      assert_match /.*\*\.5666.*LISTEN/, output, "nrpe did not start"
      pid_nrpe = shell_output("pgrep nrpe").to_i
    ensure
      Process.kill("SIGINT", pid_nrpe)
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

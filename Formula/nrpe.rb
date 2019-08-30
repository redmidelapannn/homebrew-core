class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-3.x/nrpe-3.2.1.tar.gz"
  sha256 "8ad2d1846ab9011fdd2942b8fc0c99dfad9a97e57f4a3e6e394a4ead99c0f1f0"
  revision 1

  bottle do
    cellar :any
    sha256 "b32900f10ef4e370f57010e25b75611791d760be7e594a68cd6acd307f997f72" => :mojave
    sha256 "b670d7ac585e88b572850c45e364e5ce98a36f4c547022b8ddf66cbd0d2e8b79" => :high_sierra
    sha256 "467d75262618c3102a58229f220547b8467887133cacf09d3ee055c9dd3c6aa1" => :sierra
  end

  depends_on "nagios-plugins"
  depends_on "openssl@1.1"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    system "./configure", "--prefix=#{prefix}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin",
                          "--with-piddir=#{var}/run",
                          "--sysconfdir=#{etc}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl@1.1"].opt_lib}",
                          "--enable-ssl",
                          "--enable-command-args"

    inreplace "src/Makefile" do |s|
      s.gsub! "$(LIBEXECDIR)", "$(SBINDIR)"
      s.gsub! "$(DESTDIR)/usr/local/sbin", "$(SBINDIR)"
    end

    system "make", "all"
    system "make", "install", "install-config"
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options :manual => "nrpe -n -c #{HOMEBREW_PREFIX}/etc/nrpe.cfg -d"

  def plist; <<~EOS
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

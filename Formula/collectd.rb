class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.8.0.tar.bz2"
  sha256 "b06ff476bbf05533cb97ae6749262cc3c76c9969f032bd8496690084ddeb15c9"
  revision 2

  bottle do
    rebuild 1
    sha256 "ac4462add151d979cabe5c3abd6a9b0fbc7b1d9b0ac67e64f3726f448087b2da" => :mojave
    sha256 "af5afea461d8d6a3eebc34f85340885a3f7aa961f87d4a532a57dba0cc2f6994" => :high_sierra
    sha256 "8b65819504ea639466d409768a81c8879e6ca9264d716395b7da04e7cad4efa0" => :sierra
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-java", "Enable Java support"
  option "with-python", "Enable Python support"
  option "with-riemann-client", "Enable write_riemann support"

  deprecated_option "java" => "with-java"
  deprecated_option "with-python" => "with-python@2"

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on :java => :optional
  depends_on "python@2" => :optional
  depends_on "riemann-client" => :optional

  fails_with :clang do
    build 318
    cause <<~EOS
      Clang interacts poorly with the collectd-bundled libltdl,
      causing configure to fail.
    EOS
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
    ]

    args << "--disable-java" if build.without? "java"
    args << "--enable-python" if build.with? "python@2"
    args << "--enable-write_riemann" if build.with? "riemann-client"

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/collectd -f -C #{HOMEBREW_PREFIX}/etc/collectd.conf"

  def plist; <<~EOS
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
          <string>#{sbin}/collectd</string>
          <string>-f</string>
          <string>-C</string>
          <string>#{etc}/collectd.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/collectd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/collectd.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    log = testpath/"collectd.log"
    (testpath/"collectd.conf").write <<~EOS
      LoadPlugin logfile
      <Plugin logfile>
        File "#{log}"
      </Plugin>
      LoadPlugin memory
    EOS
    begin
      pid = fork { exec sbin/"collectd", "-f", "-C", "collectd.conf" }
      sleep 1
      assert_predicate log, :exist?, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

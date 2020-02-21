class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz"
  mirror "https://archive.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz"
  sha256 "b14f7a0fece8bd34c7fffa46039e563ac5367607c612517aa7bd37306afbd1cd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "924424079816177fc3ae4e34aad45b655f6d742b98ddbb38a2c33d08b33550b7" => :catalina
    sha256 "0ceabd34af9a0247093c9a34ec69ea4193655de3bb3b7fe2efadf81babbdd8ba" => :mojave
    sha256 "424b02f64ada0d0e25c3da98456dc887ec157855397e79cd0b767fa266f99e88" => :high_sierra
  end

  head do
    url "https://svn.apache.org/repos/asf/zookeeper/trunk"

    depends_on "ant" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cppunit" => :build
    depends_on "libtool" => :build
  end

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      . "#{etc}/zookeeper/defaults"
      cd "#{libexec}/bin"
      ./#{target} "$@"
    EOS
  end

  def default_zk_env
    <<~EOS
      [ -z "$ZOOCFGDIR" ] && export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def default_log4j_properties
    <<~EOS
      log4j.rootCategory=WARN, zklog
      log4j.appender.zklog = org.apache.log4j.RollingFileAppender
      log4j.appender.zklog.File = #{var}/log/zookeeper/zookeeper.log
      log4j.appender.zklog.Append = true
      log4j.appender.zklog.layout = org.apache.log4j.PatternLayout
      log4j.appender.zklog.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss} %c{1} [%p] %m%n
    EOS
  end

  def install
    if build.head?
      system "ant", "compile_jute"
      system "autoreconf", "-fvi", "src/c"
    end

    cd "zookeeper-client/zookeeper-client-c" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--without-cppunit"
      system "make", "install"
    end

    rm_f Dir["bin/*.cmd"]

    if build.head?
      system "ant"
      libexec.install "bin", "src/contrib", "src/java/lib"
      libexec.install Dir["build/*.jar"]
    else
      libexec.install "bin", "zookeeper-contrib", "lib"
      libexec.install Dir["*.jar"]
    end

    bin.mkpath
    (etc/"zookeeper").mkpath
    (var/"log/zookeeper").mkpath
    (var/"run/zookeeper/data").mkpath

    Pathname.glob("#{libexec}/bin/*.sh") do |path|
      next if path == libexec+"bin/zkEnv.sh"

      script_name = path.basename
      bin_name    = path.basename ".sh"
      (bin+bin_name).write shim_script(script_name)
    end

    defaults = etc/"zookeeper/defaults"
    defaults.write(default_zk_env) unless defaults.exist?

    log4j_properties = etc/"zookeeper/log4j.properties"
    log4j_properties.write(default_log4j_properties) unless log4j_properties.exist?

    inreplace "conf/zoo_sample.cfg",
              /^dataDir=.*/, "dataDir=#{var}/run/zookeeper/data"
    cp "conf/zoo_sample.cfg", "conf/zoo.cfg"
    (etc/"zookeeper").install ["conf/zoo.cfg", "conf/zoo_sample.cfg"]
  end

  plist_options :manual => "zkServer start"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>EnvironmentVariables</key>
        <dict>
           <key>SERVER_JVMFLAGS</key>
           <string>-Dapple.awt.UIElement=true</string>
        </dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/zkServer</string>
          <string>start-foreground</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    output = shell_output("#{bin}/zkServer -h 2>&1")
    assert_match "Using config: #{etc}/zookeeper/zoo.cfg", output
  end
end

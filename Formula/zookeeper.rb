class Zookeeper < Formula
  desc "Centralized server for distributed coordination of services"
  homepage "https://zookeeper.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=zookeeper/zookeeper-3.4.11/zookeeper-3.4.11.tar.gz"
  sha256 "f6bd68a1c8f7c13ea4c2c99f13082d0d71ac464ffaf3bf7a365879ab6ad10e84"

  bottle do
    cellar :any
    sha256 "9865de2af6a181391bccc665f7510178a70b43f4b891b1c944115b91d8c0a2dd" => :high_sierra
    sha256 "e66f81aafdb14e9d9c603de7aa84e8e1a96da94427d98c64add8ef07a4d11a78" => :sierra
    sha256 "acf97b977d6d6e4e1e095dd7eebef8c4401a02c79fe2cc5d58143ac856328307" => :el_capitan
  end

  head do
    url "https://svn.apache.org/repos/asf/zookeeper/trunk"

    depends_on "ant" => :build
    depends_on "cppunit" => :build
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-perl", "Build Perl bindings"

  deprecated_option "perl" => "with-perl"

  depends_on "python" => :optional

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
    # Don't try to build extensions for PPC
    if Hardware::CPU.is_32_bit?
      ENV["ARCHFLAGS"] = "-arch #{Hardware::CPU.arch_32_bit}"
    else
      ENV["ARCHFLAGS"] = Hardware::CPU.universal_archs.as_arch_flags
    end

    if build.head?
      system "ant", "compile_jute"
      system "autoreconf", "-fvi", "src/c"
    end

    cd "src/c" do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--without-cppunit"
      system "make", "install"
    end

    if build.with? "python"
      cd "src/contrib/zkpython" do
        system "python", "src/python/setup.py", "build"
        system "python", "src/python/setup.py", "install", "--prefix=#{prefix}"
      end
    end

    if build.with? "perl"
      cd "src/contrib/zkperl" do
        system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                                      "--zookeeper-include=#{include}",
                                      "--zookeeper-lib=#{lib}"
        system "make", "install"
      end
    end

    rm_f Dir["bin/*.cmd"]

    if build.head?
      system "ant"
      libexec.install "bin", "src/contrib", "src/java/lib"
      libexec.install Dir["build/*.jar"]
    else
      libexec.install "bin", "contrib", "lib"
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

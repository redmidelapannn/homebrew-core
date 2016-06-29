class Openlitespeed < Formula
  desc "High-performance, lightweight HTTP server"
  homepage "http://open.litespeedtech.com/mediawiki/"
  url "http://open.litespeedtech.com/packages/openlitespeed-1.4.18.tgz"
  sha256 "30db62804ca635d8ba116f67b6690267c5fd8e8321a4e2ded98c959891b9a89c"
  head "https://github.com/litespeedtech/openlitespeed.git"

  bottle do
    sha256 "6e64c9aa8b2102467290cbea23cf64bdeee311d1f639ce1d2b710bd404b6f77d" => :el_capitan
    sha256 "c09a2fefd261d00335d852ae372441735bf3d0b05fb16f1c29f959949337b694" => :mavericks
  end

  option "with-debug", "Build with support for debug log"
  option "with-redis", "Enable redis for cache module"
  option "without-http2", "Disable SPDY and http2"

  depends_on "pcre"
  depends_on "geoip"
  depends_on "openssl"
  depends_on "expat" => :optional
  depends_on "zlib" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-pcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--enable-debug" if build.with? "debug"
    args << "--enable-redis=yes" if build.with? "redis"
    args << "--enable-http2=no" if build.without? "http2"

    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" if build.with? "zlib"

    if build.with? "expat"
      args << "--with-expat=#{Formula["expat"].opt_prefix}"
      args << "--with-expat-inc=#{Formula["expat"].opt_include}"
      args << "--with-expat-lib=#{Formula["expat"].opt_lib}"
    end

    ENV["CPPFLAGS"] = "-I#{Formula["openssl"].opt_include}/openssl"

    system "./configure", *args
    system "make"
    system "make", "install"

    inreplace bin/"lswsctrl.open",
      "RESTART_LOG=\"\$BASE_DIR\/\.\.\/logs\/lsrestart.log\"",
      "RESTART_LOG=\"#{opt_prefix}\/logs\/lsrestart.log\""
  end

  def post_install
    (prefix/"logs").mkpath
    (prefix/"admin/cgid").mkpath
  end

  plist_options :manual => "LSWS_HOME=#{HOMEBREW_PREFIX}/opt/openlitespeed lswsctrl start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnvironmentVariables</key>
      <dict>
        <key>LSWS_HOME</key>
        <string>#{prefix}</string>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/lswsctrl</string>
        <string>start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/logs/openlitespeed-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/logs/openlitespeed.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    ENV["LSWS_HOME"] = opt_prefix

    system bin/"lswsctrl", "start"
    status = `#{bin/"lswsctrl"} status`
    assert_not_nil /litespeed\sis\srunning\swith\sPID.+/.match(status)
    system bin/"lswsctrl", "stop"
  end
end

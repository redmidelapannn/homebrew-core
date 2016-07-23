class Uwsgi < Formula
  desc "Full stack for building hosting services"
  homepage "https://uwsgi-docs.readthedocs.org/en/latest/"
  url "https://projects.unbit.it/downloads/uwsgi-2.0.13.1.tar.gz"
  sha256 "2eca0c2f12ab76f032154cd147f4d5957d3195a022678d59cb507f4995a48d7f"

  head "https://github.com/unbit/uwsgi.git"

  bottle do
    sha256 "d5a13f884b3c7eb95140df8685ab8375ce749a2822cfe47d6583c479c4b9a3eb" => :el_capitan
    sha256 "b4af00a9347ddb25db351558bc22e32c43fc63d9c3b252612899cb842e914b3d" => :yosemite
    sha256 "39671f8cd9fe4a1db4d519a9592af1d38d79628628ea472f64518eac8b6d1239" => :mavericks
  end

  option "with-coro", "Compile with Perl Coro support"
  option "with-greenlet", "Compile with Python greenlet support"
  option "with-java", "Compile with Java support"
  option "with-php", "Compile with PHP support (PHP must be built for embedding)"
  option "with-ruby", "Compile with Ruby support"
  option "with-stackless", "Compile with Python stackless support"
  option "with-tornado", "Compile with Python tornado support"

  depends_on "openssl"
  depends_on "pcre"
  depends_on "pkg-config" => :build
  depends_on "sqlite" => :linked
  depends_on :python if MacOS.version <= :snow_leopard

  depends_on "geoip" => :optional
  depends_on "gloox" => :optional
  depends_on "go" => [:build, :optional]
  depends_on "jansson" => :optional
  depends_on "libffi" => :optional
  depends_on "libmatheval" => :optional
  depends_on "libxslt" => :optional
  depends_on "libyaml" => :optional
  depends_on "lua51" => :optional
  depends_on "mongodb" => :optional
  depends_on "mongrel2" => :optional
  depends_on "mono" => :optional
  depends_on "nagios" => :optional
  depends_on "postgresql" => :optional
  depends_on "pypy" => :optional
  depends_on "python" => :optional
  depends_on "python3" => :optional
  depends_on "rrdtool" => :optional
  depends_on "rsyslog" => :optional
  depends_on "tcc" => :optional
  depends_on :tuntap => :optional
  depends_on "v8" => :optional
  depends_on "zabbix" => :optional
  depends_on "zeromq" => :optional
  depends_on "yajl" if build.without? "jansson"

  def install
    # "no such file or directory: '... libpython2.7.a'"
    # Reported 23 Jun 2016: https://github.com/unbit/uwsgi/issues/1299
    ENV.delete("SDKROOT")

    ENV.append %w[CFLAGS LDFLAGS], "-arch #{MacOS.preferred_arch}"
    openssl = Formula["openssl"]
    ENV.prepend "CFLAGS", "-I#{openssl.opt_include}"
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"

    json = build.with?("jansson") ? "jansson" : "yajl"
    yaml = build.with?("libyaml") ? "libyaml" : "embedded"

    (buildpath/"buildconf/brew.ini").write <<-EOS.undent
      [uwsgi]
      ssl = true
      json = #{json}
      yaml = #{yaml}
      inherit = base
      plugin_dir = #{libexec}/uwsgi
      embedded_plugins = null
    EOS

    system "python", "uwsgiconfig.py", "--verbose", "--build", "brew"

    plugins = ["airbrake", "alarm_curl", "alarm_speech", "asyncio", "cache",
               "carbon", "cgi", "cheaper_backlog2", "cheaper_busyness",
               "corerouter", "cplusplus", "curl_cron", "dumbloop", "dummy",
               "echo", "emperor_amqp", "exception_log", "fastrouter",
               "forkptyrouter", "gevent", "graylog2", "http", "ldap",
               "legion_cache_fetch", "logcrypto", "logfile", "logpipe",
               "logsocket", "msgpack", "notfound", "pam", "ping", "psgi", "pty",
               "rawrouter", "redislog", "router_basicauth", "router_cache",
               "router_expires", "router_hash", "router_http",
               "router_memcached", "router_metrics", "router_radius",
               "router_redirect", "router_redis", "router_rewrite",
               "router_static", "router_uwsgi", "router_xmldir", "rpc",
               "signal", "spooler", "sqlite3", "sslrouter", "stats_pusher_file",
               "stats_pusher_socket", "stats_pusher_statsd", "symcall",
               "syslog", "transformation_chunked", "transformation_gzip",
               "transformation_offload", "transformation_template",
               "transformation_tofile", "transformation_toupper", "ugreen",
               "webdav", "zergpool"]

    plugins << "alarm_xmpp" if build.with? "gloox"
    plugins << "coroae" if build.with? "coro"
    plugins << "emperor_mongodb" if build.with? "mongodb"
    plugins << "emperor_pg" if build.with? "postgresql"
    plugins << "emperor_zeromq" if build.with? "zeromq"
    plugins << "fiber" if build.with? "ruby"
    plugins << "gccgo" if build.with? "go"
    plugins << "geoip" if build.with? "geoip"
    plugins << "greenlet" if build.with? "greenlet"
    plugins << "jvm" if build.with? "java"
    plugins << "jwsgi" if build.with? "java"
    plugins << "libffi" if build.with? "libffi"
    plugins << "libtcc" if build.with? "tcc"
    plugins << "logzmq" if build.with? "zeromq"
    plugins << "lua" if build.with? "lua"
    plugins << "matheval" if build.with? "libmatheval"
    plugins << "mongodb" if build.with? "mongodb"
    plugins << "mongodblog" if build.with? "mongodb"
    plugins << "mongrel2" if build.with? "mongrel2"
    plugins << "mono" if build.with? "mono"
    plugins << "nagios" if build.with? "nagios"
    plugins << "pypy" if build.with? "pypy"
    plugins << "php" if build.with? "php"
    plugins << "rack" if build.with? "ruby"
    plugins << "rbthreads" if build.with? "ruby"
    plugins << "ring" if build.with? "java"
    plugins << "rrdtool" if build.with? "rrdtool"
    plugins << "rsyslog" if build.with? "rsyslog"
    plugins << "servlet" if build.with? "java"
    plugins << "stackless" if build.with? "stackless"
    plugins << "stats_pusher_mongodb" if build.with? "mongodb"
    plugins << "tornado" if build.with? "tornado"
    plugins << "tuntap" if build.with? "tuntap"
    plugins << "v8" if build.with? "v8"
    plugins << "xslt" if build.with? "libxslt"
    plugins << "zabbix" if build.with? "zabbix"

    (libexec/"uwsgi").mkpath
    plugins.each do |plugin|
      system "python", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/#{plugin}", "brew"
    end

    python_versions = ["python", "python2"]
    python_versions << "python3" if build.with? "python3"
    python_versions.each do |v|
      system "python", "uwsgiconfig.py", "--verbose", "--plugin", "plugins/python", "brew", v
    end

    bin.install "uwsgi"
  end

  plist_options :manual => "uwsgi"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/uwsgi</string>
            <string>--uid</string>
            <string>_www</string>
            <string>--gid</string>
            <string>_www</string>
            <string>--master</string>
            <string>--die-on-term</string>
            <string>--autoload</string>
            <string>--logto</string>
            <string>#{HOMEBREW_PREFIX}/var/log/uwsgi.log</string>
            <string>--emperor</string>
            <string>#{HOMEBREW_PREFIX}/etc/uwsgi/apps-enabled</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"helloworld.py").write <<-EOS.undent
      def application(env, start_response):
        start_response('200 OK', [('Content-Type','text/html')])
        return [b"Hello World"]
    EOS

    pid = fork do
      exec "#{bin}/uwsgi --http-socket 127.0.0.1:8080 --protocol=http --plugin python -w helloworld"
    end
    sleep 2

    begin
      assert_match "Hello World", shell_output("curl localhost:8080")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

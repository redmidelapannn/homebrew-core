class CouchdbLucene < Formula
  desc "Full-text search of CouchDB documents using Lucene"
  homepage "https://github.com/rnewson/couchdb-lucene"
  url "https://github.com/rnewson/couchdb-lucene/archive/v2.1.0.tar.gz"
  sha256 "8297f786ab9ddd86239565702eb7ae8e117236781144529ed7b72a967224b700"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "39b906e95d44caf22de8a51541a3ae81fb7b925cc4e6d9de33ae8041ed3d4003" => :catalina
    sha256 "0508422724cef9306d45606787010cf968dfa64afe6d4e16aacd019edf7aec29" => :mojave
    sha256 "2af80ffb2a9e87c56b609323ad25a6aad0add8cdc9873e2f0230cb66ef1ab246" => :high_sierra
  end

  depends_on "maven" => :build
  depends_on "couchdb"
  depends_on :java => "1.8"

  def install
    system "mvn"
    system "tar", "-xzf", "target/couchdb-lucene-#{version}-dist.tar.gz", "--strip", "1"

    prefix.install_metafiles
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]

    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      cmd = "cl_#{bin_name}"
      (bin/cmd).write shim_script(bin_name)
      (libexec/"clbin").install_symlink bin/cmd => bin_name
    end

    ini_path.write(ini_file) unless ini_path.exist?
  end

  def shim_script(target); <<~EOS
    #!/bin/bash
    export CL_BASEDIR=#{libexec}/bin
    exec "$CL_BASEDIR/#{target}" "$@"
  EOS
  end

  def ini_path
    etc/"couchdb/local.d/couchdb-lucene.ini"
  end

  def ini_file; <<~EOS
    [httpd_global_handlers]
    _fti = {couch_httpd_proxy, handle_proxy_req, <<"http://127.0.0.1:5985">>}
  EOS
  end

  def caveats; <<~EOS
    All commands have been installed with the prefix 'cl_'.

    If you really need to use these commands with their normal names, you
    can add a "clbin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/clbin:$PATH"
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/couchdb-lucene/bin/cl_run"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>HOME</key>
          <string>~</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/cl_run</string>
        </array>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    # This seems to be the easiest way to make the test play nicely in our
    # sandbox. If it works here, it'll work in the normal location though.
    cp_r Dir[opt_prefix/"*"], testpath
    inreplace "bin/cl_run", "CL_BASEDIR=#{libexec}/bin",
                            "CL_BASEDIR=#{testpath}/libexec/bin"

    io = IO.popen("#{testpath}/bin/cl_run")
    sleep 2
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    io.read !~ /Exception/
  end
end

class Couchdb < Formula
  desc "Document database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=/couchdb/source/2.3.0/apache-couchdb-2.3.0.tar.gz"
  sha256 "0b3868d042b158d9fd2f504804abd93cd22681c033952f832ce846672c31f352"

  bottle do
    cellar :any
    sha256 "519ec6a55287fed21d995df731941991c767c846aeca656000ec2b7a83add691" => :mojave
    sha256 "277221a5cfeabd2e53549a4c556b46dcedfd35891af20b633e24b6ae2aeba1fc" => :high_sierra
    sha256 "c11599f90142145cd30b5f05ca0e7cfe40767c0bdf780aa409f398dade143f89" => :sierra
  end

  depends_on "erlang@19"
  depends_on "icu4c"
  depends_on "spidermonkey"

  def install
    system "./configure"
    system "make", "release"

    # No `make install` sadly
    prefix.install Dir["rel/couchdb/*"]
  end

  def post_install
    (var/"lib/couchdb").mkpath
    (var/"log/couchdb").mkpath
    (var/"run/couchdb").mkpath
  end

  plist_options :manual => "couchdb"

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
        <string>#{opt_bin}/couchdb</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    # Ensure couchdb embedded spidermonkey vm works
    system "#{bin}/couchjs", "-h"

    (testpath/"var/lib/couchdb").mkpath
    (testpath/"var/log/couchdb").mkpath
    (testpath/"var/run/couchdb").mkpath
    cp_r etc/"couchdb", testpath

    pid = fork do
      exec "#{bin}/couchdb -A #{testpath}/couchdb"
    end
    sleep 2

    begin
      assert_match "Homebrew", shell_output("curl -# localhost:5984")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end

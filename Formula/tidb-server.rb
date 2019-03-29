class TidbServer < Formula
  desc "TiDB is a MySQL compatible distributed database"
  homepage "https://www.pingcap.com/en/"
  url "https://github.com/pingcap/tidb.git",
      :tag      => "v2.1.7",
      :revision => "f5b52cb9dc5a8a546121aa6ce1fc672bd567ca48"

  bottle do
    cellar :any_skip_relocation
    sha256 "193eb21065a530ea2d99f3c9f1c0d722ccd04074c52be5e4391cd945ee78d316" => :mojave
    sha256 "aa7be837530c13ed2ae72a4e985f9bd8cd6a2c5aeb983497100044553434bfec" => :high_sierra
    sha256 "d3a87023ceb5978c8611c3bc186e9e2d202e63fa80c3b511e0c07fd9c72fc85b" => :sierra
  end

  depends_on "go" => :build

  def install
    # Change the default datadir
    inreplace "config/config.go", "/tmp/tidb", var/"tidb"
    inreplace "tidb-server/main.go", "/tmp/tidb", var/"tidb"

    # Removing the go.sum file
    # fixes a problem in go mod hashes:
    # https://stackoverflow.com/questions/54133789/go-modules-checksum-mismatch
    rm "go.sum"
    system "make", "server"
    bin.install "bin/tidb-server"
  end

  def caveats
    s = <<~EOS
      This install of TiDB uses goleveldb as the storage engine instead of TiKV,
      and is slower than a production install. Any benchmarks will be unreliable.

      tidb-server does not bundle any clients. To use the MySQL client:
      brew install mysql-client
      mysql -h 127.0.0.1 -P4000 -uroot
    EOS
    s
  end

  plist_options :manual => "tidb-server"

  def plist
    s = <<~EOS
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
          <string>#{opt_bin}/tidb-server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
    s
  end

  test do
    begin
      dir = Dir.mktmpdir

      pid = fork do
        exec bin/"tidb-server -path #{dir} -P 3999"
      end
      sleep 2

      output = shell_output("curl 127.0.0.1:3999")
      output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
      assert_match "5.7.25", output # MySQL 5.7
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end

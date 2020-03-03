class Rethinkdb < Formula
  desc "The open-source database for the realtime web"
  homepage "https://www.rethinkdb.com/"
  url "https://download.rethinkdb.com/dist/rethinkdb-2.4.0.tgz"
  sha256 "bfb0708710595c6762f42e25613adec692cf568201cd61da74c254f49fa9ee4c"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e1ea6e31e025c43440b636ad397725f946455293a7ed1cfc0bc3776353bd5e91" => :catalina
    sha256 "dd3aa1b58bcc3c2af017082ced5b633e6ad207464bbb64768629d84b3a30aada" => :mojave
    sha256 "b3f51f425fc6aea7bb87cff15b2929528166bf958bf74017db39280127071930" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"
  # Does not support python 3, as stated in the readme
  # v8 and gyp fail to build: https://github.com/Homebrew/linuxbrew-core/pull/19614
  # See also https://github.com/rethinkdb/rethinkdb/pull/6401
  uses_from_macos "python@2"

  def install
    args = ["--prefix=#{prefix}"]

    # rethinkdb requires that protobuf be linked against libc++
    # but brew's protobuf is sometimes linked against libstdc++
    args += ["--fetch", "protobuf"]

    system "./configure", *args
    system "make"
    system "make", "install-osx"

    (var/"log/rethinkdb").mkpath

    inreplace "packaging/assets/config/default.conf.sample",
              /^# directory=.*/, "directory=#{var}/rethinkdb"
    etc.install "packaging/assets/config/default.conf.sample" => "rethinkdb.conf"
  end

  plist_options :manual => "rethinkdb"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
          <string>#{opt_bin}/rethinkdb</string>
          <string>--config-file</string>
          <string>#{etc}/rethinkdb.conf</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    shell_output("#{bin}/rethinkdb create -d test")
    assert File.read("test/metadata").start_with?("RethinkDB")
  end
end

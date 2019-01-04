require "language/go"

class MongodbAT30 < Formula
  desc "High-performance document-oriented database"
  homepage "https://www.mongodb.org/"
  url "https://fastdl.mongodb.org/src/mongodb-src-r3.0.15.tar.gz"
  sha256 "09ad76e06df007085520025c94a5e5840d65f37660c2b359f4962e135e4ae259"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da27b500ae8b201028299abb42bab2b4967c682454c92145a638d503e0581678" => :mojave
    sha256 "73f3b82eb522a5f20caf3ef250ec773d20211f7256d86c5336efaddcfdeede77" => :high_sierra
    sha256 "73195032c3fbc53fea95ba298175ee45f9fc27b8d0bbbe7a168f8e644c765f65" => :sierra
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "scons" => :build
  depends_on :macos => :mountain_lion

  go_resource "github.com/mongodb/mongo-tools" do
    url "https://github.com/mongodb/mongo-tools.git",
      :tag      => "r3.0.15",
      :revision => "86d15daf966ce58f5ce01985db07a7a5a3641ecb"
  end

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # New Go tools have their own build script but the server scons "install"
    # target is still responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      system "./build.sh"
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      -j#{ENV.make_jobs}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
      --osx-version-min=#{MacOS.version}
      --prefix=#{prefix}
      --use-new-tools
    ]

    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    scons "install", *args

    (buildpath/"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
  end

  def mongodb_conf; <<~EOS
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/mongodb@3.0/bin/mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mongod</string>
        <string>--config</string>
        <string>#{etc}/mongod.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end

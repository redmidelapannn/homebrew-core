require "language/go"

class Mongodb < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.4.4.tar.gz"
    sha256 "09e962bf3428474b9790bbd464cb6176817f9da6121c30e096240dbb4d51c9f6"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
          :tag => "r3.4.4",
          :revision => "17fbdf31abca50cdfe27482b05b1476f42ecab0a",
          :shallow => false
    end
  end

  bottle do
    rebuild 1
    sha256 "765754197b8de9147159587c91888f23f1abe6be7fc8daff535a9fcb9a6c6f47" => :sierra
    sha256 "13713b007af3d95eb3bd5b51e21f07baa4bbbaf77e1649f755494dbc0bbec88a" => :el_capitan
    sha256 "ebd666e6df88a3fc14e586ecf430a2f7944de209dc7d47ac9daa582954253ff3" => :yosemite
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.5.6.tar.gz"
    sha256 "57839e0e19c5fa986d498857e7ac617c368f1a5768539b28b7740d7079ea1670"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.5.6",
        :revision => "8bda55730d30c414a71dfbe6f45f5c54ef97811d"
    end
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"
  option "with-sasl", "Compile with SASL support"

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :mountain_lion
  depends_on "scons" => :build
  depends_on "openssl" => :recommended

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks
    ENV.libcxx if build.devel?

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      args = %w[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
        ENV["CPATH"] = Formula["openssl"].opt_include
      end

      args << "sasl" if build.with? "sasl"

      system "./build.sh", *args
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
    ]

    args << "--osx-version-min=#{MacOS.version}" if build.stable?
    args << "CCFLAGS=-mmacosx-version-min=#{MacOS.version}" if build.devel?
    args << "LINKFLAGS=-mmacosx-version-min=#{MacOS.version}" if build.devel?
    args << "CC=#{ENV.cc}"
    args << "CXX=#{ENV.cxx}"

    args << "--use-sasl-client" if build.with? "sasl"
    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"
    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    if build.with? "openssl"
      args << "--ssl"

      args << "CCFLAGS=-I#{Formula["openssl"].opt_include}"
      args << "LINKFLAGS=-L#{Formula["openssl"].opt_lib}"
    end

    scons "install", *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+"mongodb").mkpath
    (var+"log/mongodb").mkpath
  end

  def mongodb_conf; <<-EOS.undent
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

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<-EOS.undent
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

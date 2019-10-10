class Arangodb < Formula
  desc "The Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.5.1.tar.gz"
  sha256 "4e648c0aff129a02dd0279303880603cd92dd27b81ef7c40dee3eded9102c1cb"
  head "https://github.com/arangodb/arangodb.git", :branch => "devel"

  bottle do
    sha256 "157d814b800d02d79b9625a6cd03200091095de5843f3deb2888eaded1a0f6d7" => :catalina
    sha256 "1a605191c5f99273616b919b9bf764750b0776cbbadcef3aa39f1cfdb52cbcf4" => :mojave
    sha256 "b0b63a8acfac47e2d9a088dfc46a5b3488802697a315c992dbca890bde8e7946" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on :macos => :yosemite
  depends_on "openssl@1.1"

  # see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87665
  fails_with :gcc => "7"

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
      :revision => "bbe29730e70dba609b57c469e8f863f032fabf3e"
  end

  def install
    ENV.cxx11

    resource("starter").stage do
      ENV.append "GOPATH", Dir.pwd + "/.gobuild"
      system "make", "deps"
      # use commit-id as projectBuild
      commit = `git rev-parse HEAD`.chomp
      system "go", "build", "-ldflags", "-X main.projectVersion=0.14.12 -X main.projectBuild=#{commit}",
                            "-o", "arangodb",
                            "github.com/arangodb-helper/arangodb"
      bin.install "arangodb"
    end

    mkdir "build" do
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF
        -DASM_OPTIMIZATIONS=OFF
        -DCMAKE_INSTALL_DATADIR=#{share}
        -DCMAKE_INSTALL_DATAROOTDIR=#{share}
        -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
        -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
        -DUSE_JEMALLOC=Off
      ]

      if ENV.compiler == "gcc-6"
        ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks"
      end

      system "cmake", "..", *args
      system "make", "install"

      %w[arangod arango-dfdb arangosh foxx-manager].each do |f|
        inreplace etc/"arangodb3/#{f}.conf", pkgshare, opt_pkgshare
      end
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    s = <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/arangod</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    require "pty"

    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp

    ohai "#{bin}/arangodb --starter.instance-up-timeout 1m --starter.mode single"
    PTY.spawn("#{bin}/arangodb", "--starter.instance-up-timeout", "1m",
              "--starter.mode", "single", "--starter.disable-ipv6",
              "--server.arangod", "#{sbin}/arangod",
              "--server.js-dir", "#{share}/arangodb3/js") do |r, _, pid|
      begin
        loop do
          available = IO.select([r], [], [], 60)
          assert_not_equal available, nil

          line = r.readline.strip
          ohai line

          break if line.include?("Your single server can now be accessed")
        end
      ensure
        Process.kill "SIGINT", pid
        ohai "shuting down #{pid}"
      end
    end
  end
end

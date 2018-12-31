require "open3"

class Arangodb < Formula
  desc "The Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.4.1.tar.gz"
  sha256 "8087d46078ecc38a9fadd1c8300e54e0a9f29ce157be1227fdc0db8533d1731d"
  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "d7cda7af60335155347249287828dbaa49998e914684135e82e3ed514c1db0ba" => :mojave
    sha256 "2dde4bc02963843f6fdeb767d27042c6245ecfffbc80880c657e2bf33b68376b" => :high_sierra
    sha256 "4347b1c572e0f1586033329d9ba2d893f12a52dbacf0fd823ad1552a697260db" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on :macos => :yosemite
  depends_on "openssl"

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  # see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87665
  fails_with :gcc do
    build 820
    cause "Generates incorrect code"
  end

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  # Version: 0.13.10
  # SHA256:  5ee32f8071cfe5ec4b06d6cd146f72bdda2933fd6e890c57cfa2fae3bfad8707
  # Commit:  38953b049a38c844ffdbf667e55e60c6cfa22e70

  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb/archive/0.13.10.tar.gz"
    sha256 "5ee32f8071cfe5ec4b06d6cd146f72bdda2933fd6e890c57cfa2fae3bfad8707"
  end

  needs :cxx11

  def install
    ENV.cxx11

    resource("starter").stage do
      ENV.append "GOPATH", Dir.pwd + "/.gobuild"
      system "make", "deps"
      system "go", "build", "-ldflags", "-X main.projectVersion=0.13.10 -X main.projectBuild=38953b049a38c844ffdbf667e55e60c6cfa22e70",
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
    PTY.spawn("#{bin}/arangodb", "--starter.instance-up-timeout", "1m", "--starter.mode", "single") do |r, _, pid|
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

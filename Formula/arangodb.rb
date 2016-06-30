class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-3.0.0.tar.gz"
  sha256 "b69d364c2d5d8ed7ab57428a111fe19b3daf8d2ad4dface12047f354c9f8be56"
  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    cellar :any
    sha256 "7786c400b88f3b661a472be165b2252d27decef111e9c6a3904f36da363b60f7" => :el_capitan
    sha256 "1ccd98bbad741504cf3139b969feb54f3839eef871858be4420fd01aa37cbd2f" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    ENV.libcxx
    mkdir "arangodb-build" do
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF
        -DASM_OPTIMIZATIONS=OFF
        -DETCDIR=#{etc}
        -DVARDIR=#{var}
      ]
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  # moving the "if" inside post_install does not work
  if build.head?
    def post_install
      (var/"lib/arangodb3").mkpath
      (var/"log/arangodb3").mkpath
    end
  else
    def post_install
      (var/"lib/arangodb3").mkpath
      (var/"log/arangodb3").mkpath
      system sbin/"arangod", "--database.auto-upgrade", "true"
    end
  end

  def caveats
    s = <<-EOS.undent
      Please note that clang and/or its standard library 7.0.0 has a severe
      performance issue. Please consider using '--cc=gcc-5' when installing
      if you are running on such a system.
    EOS

    if build.head?
      s += <<-EOS.undent
        A default password has been set. You can change it by executing
          #{sbin}/arango-secure-installation
      EOS
    end

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist; <<-EOS.undent
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
          <string>#{opt_sbin}/arangod</string>
          <string>-c</string>
          <string>#{etc}/arangodb3/arangod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    cmd = %W[
      #{bin}/arangosh
      --server.password ""
      --javascript.execute-string "require('@arangodb').print('it works!')"
    ]
    assert_equal "it works!", shell_output(cmd.join(" ")).chomp
  end
end

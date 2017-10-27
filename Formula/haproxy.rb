class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.9.tar.gz"
  sha256 "1072337e54fa188dc6e0cfe3ba4c2200b07082e321cbfe5a0882d85d54db068e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "55cbf67926e0b81ae401ffe40005dc3bc0f4045799da1e02d3d7ed9130b06182" => :high_sierra
    sha256 "c59126e8bb41f8a333d6c4aff25f497c1e2b47e776b4b8c7b0498046f8ba6ef1" => :sierra
    sha256 "3eec9be4742357261cbaf9af415d1abed04592bd651259d8b1d168e45b36a7d8" => :el_capitan
  end

  depends_on "openssl"
  depends_on "pcre"

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  def caveats; <<~EOS
    To start haproxy with brew services, first create and edit your config at:
      #{etc}/haproxy.cfg
    Logs can be found at:
      #{var}/log/haproxy.log
    EOS
  end

  plist_options :manual => "haproxy"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/haproxy</string>
          <string>-f</string>
          <string>#{etc}/haproxy.cfg</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/haproxy.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/haproxy.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end

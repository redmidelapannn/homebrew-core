class Sslsplit < Formula
  desc "Man-in-the-middle attacks against SSL encrypted network connections"
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.5.4.tar.gz"
  sha256 "3338256598c0a8af6cc564609f3bce75cf2a9d74c32583bf96253a2ea0ef29fe"
  head "https://github.com/droe/sslsplit.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "da78b0c115199bccc78d7251e3345f8dbbdc004132a2b489b6d4737334c95953" => :mojave
    sha256 "3e4cd98ddaf67d7cd6259bc1ef903faf261d6386aade2b91f82a2d38b29c2499" => :high_sierra
    sha256 "f6fc3ae2b3e79c6dfc3dd2ee986f4c3f32ce38193ddb7c1d3689c80ffcd9a2f8" => :sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libnet"
  depends_on "libpcap"
  depends_on "openssl"

  def install
    # Work around https://github.com/droe/sslsplit/issues/251
    inreplace "GNUmakefile", "$(DESTDIR)/var/", "$(DESTDIR)$(PREFIX)/var/"

    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    cmd = "#{bin}/sslsplit -D http 0.0.0.0 #{port} www.roe.ch 80"
    output = pipe_output("(#{cmd} & PID=$! && sleep 3 ; kill $PID) 2>&1")
    assert_match "Starting main event loop", output
  end
end
